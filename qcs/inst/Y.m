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

## usage: U = Y(n)
##
## Compute the operator that applies the single qubit Pauli Y gate to
## n sequential qubits
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = Y(n=1)
 
  Y1 = i*[0,-1;1,0];
  U = nBitOp(Y1,n);
  
endfunction


%!test
%! Y1 = i*[0,-1;1,0];
%! assert(Y,Y1);
%! assert(kron(Y1,Y1),Y(2));
%! assert(kron(Y1,kron(Y1,Y1)),Y(3));
