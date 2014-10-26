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

## usage: U = U2phaseamp(p)
##
## Compute a 2x2 Unitary given phase and amplitude parameters. p can
## take two forms: [theta,R,C] and [theta,R,C,G].  The first produces
## a Special Unitary operator (det(U) = 1). The later introduces a
## global phase factor of G/2. All parameters must be Real valued.
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = U2phaseamp(p)

  if( !isequal(size(p),[1,3]) && !isequal(size(p),[1,4]) ) 
    error("Parameter vector must be a length 3 or 4 row vector. \
Given something else.");
  elseif( !isreal(p) )
    error("Paramters are not real valued. They should be.");
  endif

  ## SU(2) component
  U = zeros(2);
  U(1,1) = e^(i*(p(2)-p(3))/2)*cos(p(1));
  U(2,2) = e^(i*(p(2)+p(3))/2)*cos(p(1));
  U(2,1) = e^(i*(p(3)-p(2))/2)*sin(p(1));
  U(1,2) = -e^(i*(p(3)+p(2))/2)*sin(p(1));

  ## global phase shift if needed
  if( length(p) == 4 && abs(p(4)) > 2^(-60) )
    U = e^(i*p(4))*U;
  endif

	 
endfunction

%!test
%! assert(isequal(eye(2),U2phaseamp([0,0,0])));
%! assert(isequal(eye(2),U2phaseamp([0,0,0,0])));
%! fail('U2phaseamp(i)');
%! fail('U2phaseamp(eye(3))');
%! fail('U2phaseamp([i,i,i])');
%! fail('U2phaseamp([pi,pi])');
%! fail('U2phaseamp(zeros(1,5))');
