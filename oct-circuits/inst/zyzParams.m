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

## usage: p = zyzParams(U,ep)
##
## Compute the Z-Y-Z decomposition angles for an arbitrary operator
## from U(2). The parameter ep is the threshold for "Unitariness".  
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function p = zyzParams(U,ep=0.00001)
  
  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  elseif( operr(U*U',Iop) >  ep)
    error("Given operator appears to not be unitary");	 
  endif

  ## get phase amp params
  ph = phaseAmpParams(U,ep);

  ## [z1,y,z2,global]
  p = [ph(3),(2*ph(1)),ph(2),ph(4)];

	 
endfunction

%!test
%! assert(false)
