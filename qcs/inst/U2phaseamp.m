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
## @deftypefn {Function File} {@var{U} =} U2phaseamp (@var{p})
##
## Compute the 2x2 unitary @var{U} parameterized by phase and amplitude parameters @var{p}.
##
## Any 2x2 unitary matrix @var{U} can parameterized by 4 independent, real-valued parameters. Calling @code{U2phaseamp(@var{p}} returns the 2x2 unitary parameterized by  vector @var{p} where @code{@var{p}(1)} is the amplitude parameter and @code{@var{p}(2:4)} are the row, column, and global phase parameters respectively. For consistency with @code{phaseampparams}, the amplitude should fall in [0,pi/2], the row and column parameters should fall in [-pi,pi] and the global phase should fall in [0,2pi).  Under these conditions than one can expect phaseampparams(U2phaseamp(p)) to be equivalent to p.
##
## @seealso{phaseampparams,Rnparams,zyzparams,U2Rn,U2zyz,}
## @end deftypefn

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
  U(1,1) = e^(i*(-p(2)-p(3))/2)*cos(p(1));
  U(2,2) = e^(i*(p(2)+p(3))/2)*cos(p(1));
  U(2,1) = e^(i*(p(3)-p(2))/2)*sin(p(1));
  U(1,2) = -e^(i*(-p(3)+p(2))/2)*sin(p(1));

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

## check consistency with parameterization function for principal values
%!test
%! close = 2^(-35);
%! for k = 1:200
%!   randparams = [unifrnd(0,pi/2,1,1),unifrnd(0,2*pi,1,3)];
%!   U = U2phaseamp(randparams);
%!   p = phaseampparams(U);
%!   diff = abs(randparams-p);
%!   assert( diff < close );
%! endfor
%!
