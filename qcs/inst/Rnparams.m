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
## @deftypefn {Function File} {@var{p} =} Rnparams (@var{U})
##
## Compute the parameters of a Rotation about an axis operation and global phase change that is equivalent to 2x2 unitary matrix @var{U}.
##
## Any 2x2 unitary matrix @var{U} can be rewritten as a 2x2 special unitary matrix @math{R} for a rotation about an axis of the Bloch sphere with a possible phase factor @math{g} such that @math{@var{U}=e^(i*g) * R}.  Calling @code{RnParam(@var{U}} returns the parameter vector @var{p} where @code{@var{p}(1)} is the angle of rotation, @code{@var{p}(2:4)} are the @math{(x,y,z)} corrdinates of the normalized axis of rotation, and @code{@var{p}(5)} is the global phase factor.
##
## @seealso{phaseampparams,zyzparams,U2Rn,U2zyz,U2phaseamp}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function p = Rnparams(U)
  minval = 2^(-50); #close enough to zero

  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  endif

  ## factor out global phase to get SU(2) component
  gp = arg(det(U))/2; #[-pi/2,pi/2]

  U = e^(-i*gp)*U; #factor out global phase

  theta = 2*acos( (U(1,1) + U(2,2)) / 2);

  ## disregard rounding in imaginary... should be ~0
  ##assert(abs(imag(theta)) < minval );

  theta = real(theta); #[0,2pi)

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

  ##assert(abs(imag(n)) < minval );
  n = real(n);

  p = [theta,n,gp];

endfunction

%!test
%! assert(isequal(Rnparams(eye(2)),[0,0,0,1,0]));
%! assert(isequal(Rnparams(X),[pi,1,0,0,pi/2]));
%! assert(isequal(Rnparams(Y),[pi,0,1,0,pi/2]));
%! assert(isequal(Rnparams(Z),[pi,0,0,1,pi/2]));
%! assert(isequal(Rnparams(H),[pi,sqrt(1/2),0,sqrt(1/2),pi/2]));
%! fail('Rnparams(eye(3))');
