# octave functions for Matrix-Vector Multiplication
# based quantum circuit evaluation, i.e. the evaluation of 
# a single time step where in a pure-state circuit


1;
warning( "off","Octave:broadcast");

# for a single pre-computed m<=n bit operator targeting 
# bits [t,t+m). y=Ax
#  x is the 2^n column vector 
#  A is a 2^m by 2^m unitary
#  t is the highest-order target of A. A targets [t,t+m)
#  n is the circuit size in bits
# based on paper by Kaushik, Gropp, Minkoff, and Smith
function y = applyOp(x,A,t,n)
  m = log2(rows(A));
  
  # error checking
  if( rows(A) != columns(A) || m>n) # bad operator size
    error("Operator must be square and order = 2^m for 0<=m<=n. n=%d and A is %dx%d",n,rows(A),cols(A));      
  elseif ( t>=n || (t+1)-m<0) # bad target
     error("bad target. target not in [m-1,n) : t=%d n=%d m=%d",t,n,m); 
  elseif ( length(x) != 2^n ) #bad vector
    error("vector size must be 2^n: n=%d |x|=%d",n,length(x));
  endif

  # Cases: m=n, op targets highest order bits, loweset order bits, or somewhere
  #   in the middle
  if( m == n )
    y = A*x;
  elseif ( t == n-1 ) # highest order bits [n-1,n-m]
    X=reshape(x,2^(n-m),rows(A));
    X=X*transpose(A);
    y=reshape(X,2^n,1);
  elseif ( t+1-m == 0 ) # lowest order bits [m-1,0]
    X=reshape(x,rows(A),2^(n-m));
    X=A*X;
    y=reshape(X,2^n,1);
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
    y=reshape(X,2^n,1);
  endif

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


# project to a subspace of x where the t'th bit is b, i.e.
# zero out all locations where t^th bit is !b
function y = proj(x,t,b,n)

  #error checking
  if( b < 0 || b > 1) #bad projector value
    error("b must be 0 or 1. b=%d",b);
  elseif ( t>=n || t<0 ) #bad target
    error("bad target. must be in [0,n). t=%d n=%d",t,n);
  elseif ( length(x) != 2^n ) # bad vector/bit combo
	 error("vector/dimension mismatch length(x) must be 2^n. n=%d. len=%d",n,length(x));
  endif

  # project by reshaping and masking
  X = reshape(x,2^(t),2,2^(n-t-1));
  mask = [ones(2^(t),1,2^(n-t-1)),zeros(2^t,1,2^(n-t-1))];
  
  if( b == 1 )
    mask = flipdim(mask,2);
  endif

  X = X .* mask;
  y = reshape(X,2^n,1);

endfunction

%!test
%! P = zeros(8,6);
%! for i = 0:2
%!  P(:,2*i+1) = proj(ones(8,1),i,0,3);
%!  P(:,2*i+2) = proj(ones(8,1),i,1,3);
%! endfor
%! x=[0:7]';
%! expect = double([sum(x==[0,2,4,6],2),sum(x==[1,3,5,7],2), ...
%!                  sum(x==[0,1,4,5],2),sum(x==[2,3,6,7],2), ... 
%!                   x<4,x>3]); 
%! assert(P,expect);

function y= CNot(x,c,t,n)

  # error checking
  if( c < 0 || c >= n || t < 0 || t >= n)
    error("Bad control or target. Must be in [0,n). n=%d c=%d t=%d",n,c,t);
  elseif ( length(x) != 2^n )
    error("Vector input size mismatch. len msut be 2^n. n=%d len=%d",n,length(x));
  elseif ( c == t )
    error("Control cannot be the same as target. c=%d t=%d",c,t);
  endif 
	 
  NOT = [0,1;1,0];
  a = proj(x,c,0,n); # get the unchanged, c=0 subspace
  b = applyOp(x,NOT,t,n); # apply not everywhere
  b = proj(b,c,1,n); # project result to c=1 space
  y=a+b; #sum the c=0 and c=1 spaces	 

endfunction

