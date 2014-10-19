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

## usage: p = RnParams(U,ep)
##
## Compute the Rn parameters for an arbitrary operator
## from U(2). The parameter ep is the threshold for "Unitariness" and
## defaults. to 10^(-6).
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function p = RnParams(U,ep=0.00001)
  
  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  elseif( operr(U*U',Iop) >  ep)
    error("Given operator appears to not be unitary");	 
  endif

  ## factor out global phase to get SU(2) component
  gp = arg(sqrt(det(U))); #global phase
  U = e^(-i*gp)*U; #factor out global phase

  theta = 2*acos( (U(1,1)+ U(2,2)) / 2);
  n = zeros(1,3);
  
  minval = 2^(-50); #close enough to zero

  if( abs(theta) < minval )#Identity
    theta=0;
    n(3)=1;
  ## Diagonal Matrix
  elseif( abs(U(1,2)) < minval && abs(U(2,1)) < minval ) 
    n(3) = 1;
  ## Off-Diagonal Matrix
  elseif( abs(U(1,1)) < minval && abs(U(2,2)) < minval )
    theta = pi;
    n(2) = (U(1,2)-U(2,1))/(-2);
    n(1) = (U(1,2)+U(2,1))/(-2*i);
  else
    n(3) = (U(1,1)-U(2,2))/(-2*i*sin(theta/2));
    n(2) = (U(1,2)-U(2,1))/(-2*sin(theta/2));
    n(1) = (U(1,2)+U(2,1))/(-2*i*sin(theta/2)); 
  endif

  p = [theta,n,gp];
	 
endfunction

%!test
%! assert(false)
