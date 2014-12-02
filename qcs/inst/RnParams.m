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

## usage: p = RnParams(U)
##
## Compute the Rn parameters for an arbitrary operator
## from U(2).
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function p = RnParams(U)
  minval = 2^(-50); #close enough to zero

  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  endif

  ## factor out global phase to get SU(2) component
  gp = arg(det(U))/2;

  U = e^(-i*gp)*U; #factor out global phase

  theta = 2*acos( (U(1,1)+ U(2,2)) / 2);
  ## disregard rounding in imaginary... should be ~0

  assert(abs(imag(theta)) < minval );

  theta = real(theta);

  n = zeros(1,3);

  if( abs(theta) < minval )#Identity
    theta=0;
    n(3)=1;
  ## Diagonal Matrix
  elseif( abs(U(1,2)) < minval && abs(U(2,1)) < minval )
    n(3) = 1;
  ## Off-Diagonal Matrix
  elseif( abs(U(1,1)) < minval && abs(U(2,2)) < minval )
    theta = pi;
    n(2) = -(U(1,2)-U(2,1))/2;
    n(1) = -(U(1,2)+U(2,1))/(2*i);
  else
    n(3) = -(U(1,1)-U(2,2))/(2*i*sin(theta/2));
    n(2) = -(U(1,2)-U(2,1))/(2*sin(theta/2));
    n(1) = -(U(1,2)+U(2,1))/(2*i*sin(theta/2));
  endif

  assert(abs(imag(n)) < minval );
  n = real(n);

  p = [theta,n,gp];

endfunction

%!test
%! assert(isequal(RnParams(eye(2)),[0,0,0,1,0]));
%! assert(isequal(RnParams(X),[pi,1,0,0,pi/2]));
%! assert(isequal(RnParams(Y),[pi,0,1,0,pi/2]));
%! assert(isequal(RnParams(Z),[pi,0,0,1,pi/2]));
%! assert(isequal(RnParams(H),[pi,sqrt(1/2),0,sqrt(1/2),pi/2]));
%! fail('RnParams(eye(3))');
