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
## @deftypefn {Function File} {@var{p} =} phaseampparams (@var{U})
##
## Compute the phase and amplitude parameters of for a 2x2 unitary that is equivalent to the 2x2 unitary matrix @var{U}.
##
## Any 2x2 unitary matrix @var{U} can parameterized by 4 independent, real-valued parameters. Calling @code{phaseampparams(@var{U}} returns the parameter vector @var{p} where @code{@var{p}(1)} is the amplitude parameter from [0,pi/2] and @code{@var{p}(2:4)} are the row, column, and global phase parameters from [0,2pi) respectively.
##
## @seealso{Rnparams,zyzparams,U2Rn,U2zyz,U2phaseamp}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function p = phaseampparams(U,ep=0.00001)

  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  endif

  p = zeros(1,4);

  ## get global phase
  gp = arg(sqrt(det(U)));
  if( gp < 0 )
    gp = gp+(2*pi);
  endif

  ## gp is in [0,2pi)
  p(4) = gp;

  ## factor global phase out of U to get SU(2) component
  U = sqrt(det(U))'*U;


  minval = 2^(-50); #magnitude threshold for Zero
  ##off-diagonal
  if( abs(U(1,1)) < minval && abs(U(2,2)) < minval )
    p(1) = pi/2; # snap to theta = pi/2
    p(3) = 0; # let C be zero
    p(2) = arg(U(2,1)); #-r/2
    # (-pi,pi] --> [0,2pi)
    if( p(2) > 0 )
      p(2) = -2*p(2) + 4*pi;
    elseif( p(2) < 0 )
      p(2) = -2*p(2);
    endif
  ##diagonal
  elseif( abs(U(1,2)) < minval && abs(U(2,1)) < minval )
    p(1) = 0; # snap to theta = 0
    p(3) = 0;
    p(2) =  arg(U(2,2)); #r/2
    if( p(2) < 0 )
      p(2) = 2*p(2) + 4*pi;
    elseif( p(2) > 0 )
      p(2) = 2*p(2);
    endif
  else
    ## row phase
    p(2) = arg( U(2,2)*U(2,1)' );
    if( p(2) < 0 )
      p(2) = p(2) + (2*pi);
    endif
    ## col phase
    p(3) = arg( U(2,1)*U(1,1)' );
    if( p(3) < 0 )
      p(3) = p(3) + (2*pi);
    endif
    ## 'dephase' then get acos to get [0,pi/2]
    a = e^(i*(-p(2)-p(3))/2)'*U(1,1);
    ## the result should be real-valued, let's just force it
    p(1) = acos( real(a) );

    # fix for hidden factors of -1
    if( p(1) > pi/2 )
      # factor in e^(i*pi) = -1 to global phase
      if(p(4) + pi > 2*pi )
        p(4) -= pi;
      else
        p(4) += pi;
      endif
      # recompute  amplitude
      p(1) = acos(real(e^(i*(-p(2)-p(3)+2*pi)/2)'*U(1,1)));
    endif

  endif

endfunction

%!test
%! close = 2^(-50);
%! assert(isequal(phaseampparams(eye(2)),zeros(1,4)));
%! assert(abs(phaseampparams(Z)-[0,pi,0,pi/2]) < close);
%! assert(abs(phaseampparams(X)-[pi/2,pi,0,pi/2]) < close);
%! assert(abs(phaseampparams(Y)-[pi/2,0,0,pi/2]) < close);
%! assert(abs(phaseampparams(H)-[pi/4,pi,0,pi/2])< close);

## check consistency with U2 covstructor function for principal values
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
