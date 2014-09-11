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

## usage: p = phaseAmpParams(U,ep)
##
## Compute the phase & amplitude parameters for arbitrary operator
## from U(2). The parameter ep is the threshold for "Unitariness".  
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function p = phaseAmpParams(U,ep=0.00001)
  
  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  elseif( operr(U*U',Iop) >  ep)
    error("Given operator appears to not be unitary");	 
  endif
  
  p = zeros(1,4);
  ## amplitude 
  p(1) = acos(abs(U(1,1)));
  ## row phase
  p(2) = arg(-U(1,2)) - arg(U(1,1));
  ## col phase
  p(3) = arg(U(2,1)) - arg(U(1,1));
  ## global phase 
  p(4) = arg(det(U));
	 
endfunction

%!test
%! assert(false)
