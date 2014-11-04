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

## usage: U = Iop(n)
##
## Compute the operator that applies the single qubit T, pi/8, gate to
## n sequential qubits 
##
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = T(n=1)
 
  T1 = [1,0;0,e^(i*pi/4)];
  U = nBitOp(T1,n);
  
endfunction


%!test
%! T1 = [1,0;0,e^(i*pi/4)];
%! assert(T,T1);
%! assert(kron(T1,T1),T(2));
%! assert(kron(T1,kron(T1,T1)),T(3));
