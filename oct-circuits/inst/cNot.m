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

## usage: y = cNot(x,c,t,n)
##
## apply the controlled not to n qubit pure state x using bit c as the
## control and t as the target.
##
## x should be a length 2^n normalized column vector. c and t should be in 
## [0,n) and c != t.

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function y= cNot(x,c,t,n)

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

%!test
%!  x=[0:7]'==7;
%!  expect = (ones(8,6).*[0:7]') == [6,5,6,3,5,3];
%!  res = ones(8,6).*x;
%!  c = [2,2,1,1,0,0]'; 
%!  t = [0,1,0,2,1,2]';
%!  for i = [1:6]
%!     res(:,i) = cNot(res(:,i),c(i),t(i),3);
%!  endfor
%!  assert(res,double(expect));
