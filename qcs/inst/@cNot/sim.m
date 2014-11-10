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

## Usage: [y,t] = sim(gate,in,bits,currd,dlim,currt,tlim)
## 
##  simulate the action of a @QASMcNot 'gate' on pure state
##  'in' in a system of size 'bits'.  The current simulation depth is
##  currd and dlim is the user specified simulation depth limit.
##  Similarly, currt is the current simulation time step (w.r.t to
##  dlim) and tlim is the user specified number of steps to simulate.
##  The simulation returns two results, the pure state y that results
##  from the operator and the current time step t. 
## 

## Author: Logan Mayfield
## Keyword: circuits


function [y,t] = sim(gate,in,bits,currd,dlim,currt,tlim)

  op = circ2mat(gate,bits);
  y  = op*in;	    
  if( currd <= dlim )
    t = currt+1;
  else
    t = currt;
  endif

endfunction

## all tests use binaryRep and stdBasis 
%!test    
%! for k = 0:3
%!   for c = 0:1
%!        t = mod(c+1,2); # target
%!        in = (0:3==k)'; 
%!        out = binaryRep(k,2); 
%!        out(2-t) = mod(out(2-c)+out(2-t),2);
%!        out = stdBasis(out,2);
%!        [y,ti] = sim(@cNot(t,c),in,2,0,1,0,1);
%!        assert(isequal(y,out),
%!               "error on in = %d ctrl=%d tar=%d. got %d expected %d",...
%!                find(in)-1, c, t, find(y)-1, find(out)-1);         
%!   endfor
%! endfor
%!

%!test 
%! for k = 0:(2^4-1)
%!   for c = 0:3
%!     for t = setdiff(0:3,[c])
%!        in = (0:(2^4-1)==k)'; 
%!        out = binaryRep(k,4); 
%!        out(4-t) = mod(out(4-c)+out(4-t),2);
%!        out = stdBasis(out,4);
%!        [y,ti] = sim(@cNot(t,c),in,4,0,1,0,1);
%!        assert(ti==1);
%!        assert(isequal(y,out), ...
%!               "error on in = %d ctrl=%d tar=%d. got %d expected %d",...
%!                find(in)-1, c, t, find(y)-1,find(out)-1 );
%!     endfor
%!   endfor
%! endfor

## larger space and depth check
%!test 
%! for k = 0:(2^5-1)
%!   for c = 0:4
%!     for t = setdiff(0:4,[c])
%!        in = (0:(2^5-1)==k)'; 
%!        out = binaryRep(k,5); 
%!        out(5-t) = mod(out(5-c)+out(5-t),2);
%!        out = stdBasis(out,5);
%!        [y,ti] = sim(@cNot(t,c),in,5,2,1,0,1);
%!        assert(ti==0);
%!        assert(isequal(y,out), ...
%!               "error on in = %d ctrl=%d tar=%d. got %d expected %d",...
%!                find(in)-1, c, t, find(y)-1,find(out)-1 );
%!     endfor
%!   endfor
%! endfor
