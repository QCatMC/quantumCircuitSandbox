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
## @deftypefn {Function File} {@var{U} =} Rn (@var{t},@var{n})
##
## Compute a 2x2 Unitary for rotating t radians about the unit length @math{(x,y,z)} axis @var{n} the Bloch sphere.
##
## @seealso{Iop,H,X,Y,Z,S,T,Rx,Ry,Rz,Ph}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = Rn(t,n)

  if( !isscalar(t) || !isreal(t) )
    error("Angle theta must be real. Given something else.")
  elseif( !isreal(n) || !isequal(size(n),[1,3]) )
    error("Rotation axis n must be a 3D real vector");
  elseif( abs(1 - n*n') > 0.0000001)
    error("Rotation axis must have unit length.");
  endif

  A = n(1)*X + n(2)*Y + n(3)*Z;
  U = e^(-i*t/2*A);

endfunction

%!test
%! fail('Rn([0,1],sqrt(1/3)*[1,1,1])');
%! fail('Rn(i,sqrt(1/3)*[1,1,1])');
%! fail('Rn(pi,[1,2,3])');
%! fail('Rn(pi,[i,i,i])');
%! fail('Rn(pi,sqrt(1/4)*[1,1,1,1])');
%! fail('Rn(pi,[1/2,1/2,1/2])');
%! assert(isequal(eye(2),Rn(0,[0,0,1])));
