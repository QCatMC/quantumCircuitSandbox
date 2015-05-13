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

## Usage: b = isnat(n)
##
## true if n is a natural number or vector of natural numbers. 
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits


function b = isnat(n)

  for k = 1:length(n)
    if(!isscalar(n(k)) || floor(n(k))!=ceil(n(k)) || n(k)<0)
      b = false;
      return;
    endif
  endfor

  b=true;
endfunction

%!test
%! assert(isnat(0));
%! assert(isnat(3));
%! assert(!isnat(-1));
%! assert(!isnat(1/2));
%! assert(isnat(1:4));
%! assert(isnat([0,5,1,3,15,8]))
%! assert(!isnat(0:1/2:5))
%! assert(!isnat(5:-1:-5))
