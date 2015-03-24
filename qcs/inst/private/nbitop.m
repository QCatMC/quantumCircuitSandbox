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

## usage: U = nbitop(Op,n)
##
## Compute the operator that applies the single qubit gate Op to
## n sequential qubits 
##
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = nbitop(Op,n=1)
 
  ## error check number of qubits
  if( n < 0 )
    error("Number of qubits must be 0 or greater. Given n=%d",n);
  elseif( size(Op) != [2,2] )
    error("Op must be 2x2, single qubit, operator. Given %dx%d", ...
	  rows(Op),columns(Op));
  endif


  U = [1];
  for i = 1:n
    U=kron(U,Op);
  endfor
  
endfunction


%!test
%! H1 = sqrt(1/2)*[1,1;1,-1];
%! assert(nbitop(H1),H1);
%! assert(kron(H1,H1),nbitop(H1,2));
%! assert(kron(H1,kron(H1,H1)),nbitop(H1,3));
