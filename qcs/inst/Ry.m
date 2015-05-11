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

## -*- texinfo -*-
## @deftypefn {Function File} {@var{U} =} Ry (@var{t})
##
## Compute a 2x2 Unitary for rotating t radians about the y-axis of the the Bloch sphere.
##
## @seealso{Iop,H,X,Y,Z,S,T,Rn,Rx,Rz,Ph}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = Ry(t)

  if( !isscalar(t) || !isreal(t) )
    error("Angle theta must be real. Given something else.")
  endif

  U = cos(t/2)*eye(2)-i*sin(t/2)*[0,-i;i,0];

endfunction


%!test
%! fail('Ry(i)');
%! fail('Ry(eye(2))');
%! fail('Ry(ones(1,2))');
