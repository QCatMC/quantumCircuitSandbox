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

## usage: U = U2Rn(p)
##
## Compute a 2x2 Unitary for rotating t radians about the vector (n1,n2,n3) of
## the Bloch sphere.  
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = U2Rn(p)

  if( !(isequal(size(p),[1,4]) || isequal(size(p),[1,5])) ) 
    error("Parameter vector must be a length 4 or 5 row vector. \
Given something else.");
  elseif( !isreal(p) )
    error("Paramters are not real valued. They should be.");
  endif
  
  ## get global phase;
  if( length(p) == 4)
    g = 0;
  else
    g = p(5);
  endif
  t = p(1);
  n = p(2:4);

  U = e^(i*g/2)*Rn(t,n);
	 
endfunction

%!test
%! assert(false)
