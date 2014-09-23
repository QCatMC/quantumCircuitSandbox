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

## usage: U = U2zyz(p)
##
## Compute a 2x2 Unitary given zyz decomposition parameters. p can
## take two forms: [z,y,z] and [z,y,z,g]. The first produces
## a Special Unitary operator (det(U) = 1). The later introduces a
## global phase factor of g/2. All parameters must be Real valued.
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = U2zyz(p)

  if( !(isequal(size(p),[1,3]) || isequal(size(p),[1,4])) ) 
    error("Parameter vector must be a length 3 or 4 row vector. \
Given something else.");
  elseif( !isreal(p) )
    error("Paramters are not real valued. They should be.");
  endif
  
  ## get global phase;
  if( length(p) == 3)
    g = 0;
  else
    g = p(4);
  endif

  U = e^(i*g/2)*(Rz(p(1))*Ry(p(2))*Rz(p(3)));
	 
endfunction

%!test
%! assert(false)
