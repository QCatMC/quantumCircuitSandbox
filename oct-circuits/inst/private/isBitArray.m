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

## usage: b = isBitArray(arr);
##
## Return true if arr is a row vector comprised of zeros and ones.
##
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Misc

function b = isBitArray(arr)
  b = true;
  arrSize = size(arr);
  if ( arrSize(1) != 1 || length(arrSize) != 2)
     b=false; return;
  else
    for k = 1:length(arr)
      if( floor(arr(1)) != ceil(arr(1)) || arr(1) < 0 || arr(1) > 1)
	b=false; return;
      endif
    endfor
  endif

endfunction

%!test
%! assert(isBitArray([0]));
%! assert(isBitArray([1]));
%! assert(!isBitArray([3]));
%! assert(!isBitArray([1.1]));
%! assert(!isBitArray([-11]));
%! assert(isBitArray(0:4));
%! assert(isBitArray([0,1,0,1,1,1,0]));
