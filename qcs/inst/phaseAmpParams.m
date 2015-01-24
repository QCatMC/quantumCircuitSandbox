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
## @deftypefn {Function File} {@var{p} =} phaseAmpParams (@var{U})
##
## Compute the phase and amplitude parameters of for a 2x2 unitary that is equivalent to the 2x2 unitary matrix @var{U}.
##
## Any 2x2 unitary matrix @var{U} can parameterized by 4 independent, real-valued parameters. Calling @code{phaseAmpParams(@var{U}} returns the parameter vector @var{p} where @code{@var{p}(1)} is the amplitude parameter and @code{@var{p}(2:4)} are the row, column, and global phase parameters respectively. 
##
## @seealso{RnParams,zyzParams,U2Rn,U2zyz,U2phaseamp}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function p = phaseAmpParams(U,ep=0.00001)

  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  endif

  p = zeros(1,4);

  ## get global phase
  gp = arg(det(U))/2;
  ## gp values range from (-pi/2,pi/2]
  p(4) = gp;

  ## factor global phase out of U to get SU(2) component
  U = e^(-i*gp)*U;


  minval = 2^(-50); #magnitude threshold for Zero
  ##off-diagonal
  if( abs(U(1,1)) < minval && abs(U(2,2)) < minval )
    p(1) = pi/2; # snap to theta = pi/2
    p(2) = 0; # let C be zero
    p(3) = 2*( arg(U(2,1)) );
  ##diagonal
  elseif( abs(U(1,2)) < minval && abs(U(2,1)) < minval )
    p(1) = 0; # snap to theta = 0
    p(2) = 0;
    p(3) = 2*( arg(U(2,2)) );
  else
    p(1) = acos(abs( U(1,1) ));
    ## row phase
    p(2) = arg( U(2,2)*U(2,1)' );
    ## col phase
    p(3) = arg( U(2,1)*U(1,1)' );
  endif

endfunction

%!test
%! close = 2^(-50);
%! assert(isequal(phaseAmpParams(eye(2)),zeros(1,4)));
%! assert(abs(phaseAmpParams(Z)-[0,0,pi,pi/2]) < close);
%! assert(abs(phaseAmpParams(X)-[pi/2,0,-pi,pi/2]) < close);
%! assert(abs(phaseAmpParams(Y)-[pi/2,0,0,pi/2]) < close);
%! assert(abs(phaseAmpParams(H)-[pi/4,pi,0,pi/2])< close);
