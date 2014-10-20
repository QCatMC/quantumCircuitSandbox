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

## usage: p = phaseAmpParams(U)
##
## Compute the phase & amplitude parameters for arbitrary operator
## from U(2). Assumes that U is Unitary. 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function p = phaseAmpParams(U,ep=0.00001)
  
  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  endif
  
  p = zeros(1,4);
  
  ## get global phase
  gp = det(U);
  p(4) = arg(gp);
  ## factor global phase out of U to get SU(2) component
  U = sqrt(gp)'*U;


  minval = 2^(-50); #magnitude threshold for Zero
  ##off-diagonal 
  if( abs(U(1,1)) < minval && abs(U(2,2)) < minval )
    p(1) = pi/2; # snap to theta = pi/2
    p(2) = 0; # let C be zero 
    p(3) = 2*( arg(U(2,1)) );
  ##diagonal
  elseif( abs(U(1,2)) < minval && abs(U(2,1)) < minval )
    p(1) = 0; # snap to theta = 0 
    p(2) = 0;
    p(3) = 2*( arg(U(2,2)) );
  else
    p(1) = acos(abs( U(1,1) ));
    ## row phase
    p(2) = arg( U(2,2)*U(2,1)' );
    ## col phase
    p(3) = arg( U(2,1)*U(1,1)' );
  endif  
	 
endfunction

%!test
%! close = 2^(-50);
%! assert(isequal(phaseAmpParams(eye(2)),zeros(1,4)));
%! assert(isequal(phaseAmpParams(Z),[0,0,pi,pi]));
%! assert(isequal(phaseAmpParams(X),[pi/2,0,-pi,pi]));
%! assert(isequal(phaseAmpParams(Y),[pi/2,0,0,pi]));
%! assert(isequal(phaseAmpParams(H),[pi/4,pi,0,pi]));
