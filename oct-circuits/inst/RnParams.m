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

  ## get phase amp params
  ph = phaseAmpParams(U,ep);

  p = zeros(1,5);
  ## global phase
  p(5) = ph(4);
  a=ph(1);
  r=ph(2);
  c=ph(3);
  ## angle
  p(1) = 2*acos(cos((r+c)/2)*cos(a));
  
  if( p(1) == 0 )
    ## default to Zero rotation about z axis when no rotation occurs
    p(2) = 0;
    p(3) = 0;
    p(4) = 1;
  else
    ## nx
    p(2) = sin((r-c)/2)*sin(a)*csc(p(1)/2);
    ## ny
    p(3) = cos((r-c)/2)*sin(a)*csc(p(1)/2);
    ## nz
    p(4) = sin((r+c)/2)*cos(a)*csc(p(1)/2);
  endif
	 
endfunction

%!test
%! assert(false)
