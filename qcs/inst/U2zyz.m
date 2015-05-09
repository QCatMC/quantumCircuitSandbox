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
## @deftypefn {Function File} {@var{U} =} U2zyz (@var{p})
##
## Compute the 2x2 unitary parameterized by the ZYZ parameters @var{p}.
##
## Any 2x2 unitary matrix @var{U} can parameterized by as the composition of a rotation about the Z, then Y, then Z axes, possibly with a global phase factor. Calling @code{U2zyz(@var{p}} returns the 2x2 unitary that corresponds to ZYZ parameter vector @var{p} where @code{@var{p}(1)} is angle of rotation for the first Z axis rotation, @code{@var{p}(2)} is the angle of rotation for the Y axis rotation, @code{@var{p}(3)} is the angle of rotation for the final Z axis rotation, and @code{@var{p}(4)} is the global phase factor. For consistency with zyzparams, the Z axis rotations should range from [0,2pi], the Y axis rotation should range from [0,pi], and the global phase factor should range from [-pi/2,pi/2].
##
## @seealso{phaseampparams,Rnparams,zyzparams,U2Rn,U2phaseamp}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = U2zyz(p)

  if( !isequal(size(p),[1,3]) && !isequal(size(p),[1,4]) )
    error("Parameter vector must be a length 3 or 4 row vector. \
Given something else.");
  elseif( !isreal(p) )
    error("Paramters are not real valued. They should be.");
  endif

  ## SU(2) component
  U = (Rz(p(1))*Ry(p(2))*Rz(p(3)));

  ## global phase if needed
  if( length(p) == 4 && abs(p(4)) > 2^(-60) )
    U = e^(i*p(4))*U;
  endif


endfunction


%!test
%! assert(isequal(eye(2),U2zyz([0,0,0])));
%! assert(isequal(eye(2),U2zyz([0,0,0,0])));
%! fail('U2zyz(i)');
%! fail('U2zyz(eye(3))');
%! fail('U2zyz([i,i,i,i])');
%! fail('U2zyz([pi,pi])');
%! fail('U2zyz(zeros(1,6))');

%!test
%! close = 2^(-35);
%! for k = 1:200
%!   rp = [unifrnd(0,2*pi,1,1),unifrnd(0,pi,1,1), ...
%!              unifrnd(0,2*pi,1,2)];
%!   U = U2zyz(rp);
%!   p = zyzparams(U);
%!   V = Rz(rp(1))*Ry(rp(2))*Rz(rp(3))*Ph(rp(4));
%!   diff = abs(rp-p);
%!   assert( diff < close , "%f ", rp, p  );
%!   assert(norm(U-V) < close );
%! endfor
%!
