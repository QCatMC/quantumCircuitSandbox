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
## @deftypefn {Function File} {@var{SU} =} SUafy (@var{U})
## @deftypefn {Function File} {[@var{SU},@var{gp}] =} SUafy (@var{U})
##
## Decompose a global phase factor and Special Uniatry matrix for an arbitrary Unitary @var{U}
##
## Any unitary matrix @var{U} can be written as a Special Unitary matrix @var{SU}(with determinant 1) and a glolbal phase factor @var{gp} such that @math{@var{U}=e^(i*gp)*SU}. Calling @code{SUafy(@var{U})} recovers such a special unitary, and if needed the global phase, for any unitary matrix. It is assumed that @var{U} is unitary.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Misc

function [SU,gp] = SUafy(U)

  if( rows(U) != columns(U) )
    error("Expected square matrix");
  endif

  dU = det(U);

  if( abs(1.0 - dU) < 2^(-40) )
    SU = U; gp = 0 ;
  else
    n = rows(U);
    gp = arg(dU)/n;
    SU = e^(-i*gp)*U;
  endif

endfunction

%!test
%! in = H;
%! [U,p] = SUafy(in);
%! assert(abs(det(U) - 1.0) <= 2^(-40));
%! r = e^(i*p)*U;
%! assert(operr(r,in) <= 2^(-40));
%! in = H(2);
%! [U,p] = SUafy(in);
%! assert(abs(det(U) - 1.0) <= 2^(-40));
%! r = e^(i*p)*U;
%! assert(operr(r,in) <= 2^(-40));
%! in = H(3);
%! [U,p] = SUafy(in);
%! assert(abs(det(U) - 1.0) <= 2^(-40));
%! r = e^(i*p)*U;
%! assert(operr(r,in) <= 2^(-40));
%! in = H(5);
%! [U,p] = SUafy(in);
%! assert(abs(det(U) - 1.0) <= 2^(-40));
%! r = e^(i*p)*U;
%! assert(operr(r,in) <= 2^(-40));
