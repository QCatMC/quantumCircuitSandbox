## Copyright (C) 2014  James Logan Mayfield
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Usage: y = applyOp(x,A,t,n)
##
## apply the m<=n bit operator A to bits [t-m+1,t] of 
## the n qubit pure state x. 
##
## A should be a 2^m x 2^m unitary matrix where m <= n. The target 
## t should be in [t-m+1,n). x should be a normalized 2^n column
## vector. 
##
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
