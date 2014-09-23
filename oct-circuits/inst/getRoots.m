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

## usage: Us = getRoots(U)
##
## Compute the 4 square roots of 2x2 Unitary matrix U.
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function Us = getRoots(U,ep=0.00001)
  
  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2.");
  elseif( operr(U*U',Iop) > ep )
    error("Operator does not appear to be unitary");
  endif

  Us = zeros(2,2,4);
  s = sqrt(det(U));
  S = s*eye(2);
  t = sqrt(trace(U) + 2*s)^(-1);

  Us(:,:,1) = t*(U+S);
  Us(:,:,2) = -t*(U+S);
  Us(:,:,3) = t*(U-S);
  Us(:,:,4) = -t*(U-S);  
	 
endfunction

%!test
%! assert(false)
