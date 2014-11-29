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

## Usage: [SU,gp] = SUafy(U)
##
##  Given a Unitary U, compute the Special Unitary and
##  and phase components s.t. U = e^(i*gp)*SU

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Misc

function [SU,gp] = SUafy(U)
  if( rows(U) != columns(U) )
    error("Expected square matrix");
  endif

  dU = det(U);
  if( abs(1.0 - dU) < 2^(-40) )
    SU = U; gp = 1.0;
  else
    n = rows(U);
    gp = arg(dU)/n;
    SU = e^(-i*gp)*U;
  endif
endfunction

%!test
%! assert(false)
