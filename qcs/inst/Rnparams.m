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

  paparams = phaseampparams(U);
  ## factor out global phase to get SU(2) component
  gp = paparams(4);
  theta = 0;
  n = zeros(1,3);

  r = paparams(2);
  c = paparams(3);
  phi = paparams(1);
  ##Identity
  if( abs(phi) < minval && abs(r) < minval && abs(c) < minval )
    theta=0;
    n(3)=1;
  ## Diagonal Matrix
  elseif( abs(phi) < minval  )
    n(3) = 1;
    theta = 2*acos(real(e^(i*(r+c)/2)*cos(phi)));
  ## Off-Diagonal Matrix
  elseif( abs(pi/2 - phi) < minval )
    theta = pi;
    n(2) = real(e^(i*(-r+c)/2));
    n(1) = -imag(e^(i*(-r+c)/2));
    if( abs(n(1)) < minval )
      n(1) = 0;
    endif
  ## general matrix
  else
    theta = 2*acos(real(e^(i*(r+c)/2)*cos(phi)));
    n(3) = (-imag( e^(i*(-r-c)/2)*cos(phi) ))/sin(theta/2);
    n(2) = real( e^(i*(-r+c)/2)*sin(phi)/sin(theta/2) );
    n(1) = -imag( e^(i*(-r+c)/2)*sin(phi)/sin(theta/2) );
  endif

  ## re-normalize and force real ... just in case? This
  ## may be a bad idea
  n = real(n/norm(n));

  ## set params
  p = [theta,n,gp];

endfunction

%!test
%! minval = 2^-40;
%! assert( abs(Rnparams(eye(2)) - [0,0,0,1,0]) < minval );
%! assert( abs(Rnparams(X)-[pi,1,0,0,pi/2]) < minval );
%! assert( abs(Rnparams(Y)-[pi,0,1,0,pi/2]) < minval );
%! assert( abs(Rnparams(Z)-[pi,0,0,1,pi/2]) < minval );
%! assert( abs(Rnparams(H)-[pi,sqrt(1/2),0,sqrt(1/2),pi/2]) < minval);
%! fail('Rnparams(eye(3))');

## check consistency with parameterization function for principal values
## Note that Rnparams(U2Rn(p)) might be a rotation around the negation
## of the axis given in p. The operators themselves are 'equivalent'
%!test
%! close = 2^(-35);
%! for k = 1:500
%!   axis = unifrnd(-1,1,1,3);
%!   axis = axis/(norm(axis));
%!   rp = [unifrnd(0,2*pi,1,1),axis,unifrnd(0,2*pi,1,1)];
%!   U = U2Rn(rp);
%!   p = Rnparams(U);
%!   V = U2Rn(p);
%!   assert( operr(U,V) < close, "failed: [%f,%f,%f,%f,%f]", ...
%!    rp(1),rp(2),rp(3),rp(4),rp(5));
%! endfor
%!
