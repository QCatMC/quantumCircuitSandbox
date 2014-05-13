## Usage: y = applyOp(x,A,t,n)
##
## apply the pre-computed m<=n bit operator A with target 
## bits [t,t+m). i.e. compute y=Ax
##  x is a 2^n column vector of a pure state
##  A is a 2^m by 2^m unitary matrix for the operator
##  t is the highest-order target of A. A targets [t,t-m)
##  n is the circuit size in bits
## based on paper by Kaushik, Gropp, Minkoff, and Smith

## Author: Logan Mayfield
## Keyword: Circuits

function y = applyOp(x,A,t,n)
  m = log2(rows(A));
  
  # error checking
  if( rows(A) != columns(A) || m>n) # bad operator size
    error("Operator must be square and order = 2^m for 0<=m<=n. n=%d and A is %dx%d", ...
	  n,rows(A),cols(A));      
  elseif ( t>=n || (t+1)-m<0) # bad target
     error("bad target. target not in [m-1,n) : t=%d n=%d m=%d",t,n,m); 
  elseif ( length(x) != 2^n ) #bad vector
    error("vector size must be 2^n: n=%d |x|=%d",n,length(x));
  endif

  # Cases: m=n, op targets highest order bits, loweset order bits, or somewhere
  #   in the middle
  if( m == n ) #
    y = A*x;
  elseif ( t == n-1 ) # highest order bits [n-1,n-m]
    X=reshape(x,2^(n-m),rows(A));
    X=X*transpose(A);
  elseif ( t+1-m == 0 ) # lowest order bits [m-1,0]
    X=reshape(x,rows(A),2^(n-m));
    X=A*X;
  else # in the middle
    #    n = high+m+low
    high = (n-1)-t; # number of untargeted, high-order bits
    low = t-m+1; # number of untargeted low order bits
        
    # need series of Xs.. 
    X=reshape(x,2^low,rows(A),2^high);
    Atrans = transpose(A);
    #iterate over Xs
    for i = 1:(2^high)
	X(:,:,i)=X(:,:,i)*Atrans;
    endfor
  endif

    y=reshape(X,2^n,1);
endfunction

%!test
%! x = [0:7]'==7;
%! NOT = [0,1;1,0];
%! R = zeros(8,3);
%! for i = 2:-1:0
%!    R(:,3-i) = applyOp(x,NOT,i,3);
%! endfor
%! expect = double([[0:7]'==3,[0:7]'==5,[0:7]'==6]);
%! assert(R,expect);
