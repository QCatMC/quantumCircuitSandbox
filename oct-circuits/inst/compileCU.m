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

## usage: U = compileCU(udesc,t,c)
##
## Compiles a circuit descriptor for arbitrary controlled unitary
## operations using more elementary operators. Allowed unitary
## descriptors are phaseamp and Rn.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function cu = compileCU(udesc,t,c)

  if( !iscell(udesc) )
    error("Expecting a U(2) descriptor and given something else.");
  elseif( length(udesc) != 2 || !ischar(udesc(1)) || ...
	  !(isreal(udesc(2)) && isequal(size(udesc(2)),[1,5])))
    error("U(2) descriptor improperly formatted.");
  endif

  
	 	 
  cd={};
  
	 
endfunction


%!test
%! assert(false);
