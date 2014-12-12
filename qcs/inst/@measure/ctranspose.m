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

## Usage: g = ctranspose(g)
##
##   Technically, measurement has no inverse/revesre/complex conjugate.
##   it's a destructive, non-reversible operation. That being said,
##   Projector's are self-inverse, so that's what we'll return.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function s = ctranspose(g)

   s = @measure(g.tar);

endfunction

%!test
%! err = 2^-40;
%! assert( operr(circ2mat(@measure(0:3),4)', ...
%!               circ2mat(@measure(0:3)',4) ) < err );
