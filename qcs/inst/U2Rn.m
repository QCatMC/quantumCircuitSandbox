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
## @deftypefn {Function File} {@var{U} =} U2Rn (@var{p})
##
## Compute the 2x2 unitary @var{U} corresponding to the Rotation about an axis parameters @var{p}.
##
## Any 2x2 unitary matrix @var{U} can be rewritten as a 2x2 special unitary matrix @math{R} for a rotation about an axis of the Bloch sphere with a possible phase factor @math{g} such that @math{@var{U}=e^(i*g) * R}.  Calling @code{U2Rn(@var{p}} returns the unitary @var{U} where @code{@var{p}(1)} is the angle of rotation, @code{@var{p}(2:4)} are the @math{(x,y,z)} corrdinates of the normalized axis of rotation, and @code{@var{p}(5)} is the global phase factor. The global phase factor may be ommited from @var{p}. For consistency with RnParams, the angle of rotation should be from [0,2pi) and the global phase factor should be in [-pi/2,pi], and the axis of rotation should be a unit length vector from R^3.
##
## @seealso{Rnparams, phaseAmpParams,zyzParams,U2zyz,U2phaseamp}
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = U2Rn(p)

  if( !isequal(size(p),[1,4]) && !isequal(size(p),[1,5]) )
    error("Parameter vector must be a length 4 or 5 row vector. \
Given something else.");
  elseif( !isreal(p) )
    error("Paramters are not real valued. They should be.");
  endif

  ## get global phase;
  if( length(p) == 4)
    g = 0;
  else
    g = p(5);
  endif

  t = p(1);
  n = p(2:4);

  U = e^(i*g)*Rn(t,n);

endfunction


%!test
%! assert(isequal(eye(2),U2Rn([0,0,0,1])));
%! assert(isequal(eye(2),U2Rn([0,0,0,1,0])));
%! fail('U2Rn(i)');
%! fail('U2Rn(eye(3))');
%! fail('U2Rn([i,i,i,i])');
%! fail('U2Rn([pi,pi])');
%! fail('U2Rn(zeros(1,6))');

## check consistency with parameterization function for principal values
%!test
%! close = 2^(-35);
%! for k = 1:500
%!   axis = unifrnd(-1,1,1,3);
%!   axis = axis/(norm(axis));
%!   randparams = [unifrnd(0,2*pi,1,1),axis,unifrnd(-pi/2,pi/2,1,1)];
%!   U = U2Rn(randparams);
%!   p = RnParams(U);
%!   diff = abs(randparams-p);
%!   assert( diff < close );
%! endfor
%!
