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
  
  ##if(!isequal(size(U),[2,2]) )
  ##  error("Operator size mismatch. Must be 2x2 Unitary.");
  ##elseif( operr(U*U',Iop) >  ep)
  ##  error("Given operator appears to not be unitary");	 
  ##endif
  
  p = zeros(1,4);
  
  ## get global phase
  gp = det(U);
  p(4) = arg(gp);
  ## factor global phase out of U to get SU(2) component
  U = sqrt(gp)'*U;

  ## get the amplitude
  p(1) = acos(abs( U(1,1) ));
  
  md = abs(U(1,1))+abs(U(2,2));
  od = abs(U(1,2))+abs(U(2,1));
  fcmpeta = 10^(-12);
  ## non-diagonal or off-diagonal matrix
  if( md > fcmpeta && od > fcmpeta )
    ## row phase
    p(2) = arg( U(2,2)*U(2,1)' );
    ## col phase
    p(3) = arg( U(2,1)*U(1,1)' );
  ##off-diagonal 
  elseif( md < fcmpeta )
    p(2) = 0; # let C be zero 
    p(3) = 2*( arg(U(2,1)) );
  ##diagonal
  elseif( od < fcmpeta )
    p(2) = 0;
    p(3) = 2*( arg(U(2,2)) );
  endif  
	 
endfunction

%!test
%! assert(false)
