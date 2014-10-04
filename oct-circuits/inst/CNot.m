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

## usage: U = CNot(c,t)
##
## Compute the operator that applies a Controlled-Not in the 
## (max(t,c)-min(t,c))+1 qubit space with control qubit c and target 
## qubit t being the smallest and largest order qubit in the space. By
## default, the control is assumed to be the high-order bit.  


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = CNot(c=1,t=0)
 
  if( c == t )
    error("Control and target cannot be the same qubit.");
  elseif( t != 0 && c != 0)
    error("Either c or t must be 0");
  elseif( c < 0 || t < 0 )
    error("Control and target must be in [0,max(t,c))");
  endif
  
  numBits = max(t,c)+1;
  P0 = [1,0;0,0];
  P1 = [0,0;0,1];

  if( c > t )
    U = kron(P0,Iop(numBits-1)) + kron(P1,kron(Iop(numBits-2),X));
  else
    U = kron(Iop(numBits-1),P0) + kron(kron(X,Iop(numBits-2)),P1);
  endif
  
endfunction


%!test
%! CNot10 = [1,0,0,0;0,1,0,0;0,0,0,1;0,0,1,0];
%! CNot01 = [1,0,0,0;0,0,0,1;0,0,1,0;0,1,0,0];
%! assert(CNot10,CNot(1));
%! assert(CNot01,CNot(0,1));
%! % I should test more cases...
