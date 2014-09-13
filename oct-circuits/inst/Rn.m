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

## usage: U = Rn(t,n)
##
## Compute a 2x2 Unitary for rotating t radians about the vector (n1,n2,n3) of
## the Bloch sphere. 
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = Rn(t,n)

  if( !isscalar(t) && !isreal(t) )
    error("Angle theta must be real. Given something else.")
  elseif( !isreal(n) || !isequal(size(n),[1,3]) )
    error("Rotation axis n must be a 3D real vector");
  elseif( (1 - n*n') > 0.0000001)
    error("Rotation axis must have unit length.");
  endif
  
  A = n(1)*X + n(2)*Y + n(3)*Z;
  U = e^(-i*t/2*A);
	 
endfunction

%!test
%! assert(false)
