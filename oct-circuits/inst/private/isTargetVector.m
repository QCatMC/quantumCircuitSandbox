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

## usage: b = isTargetVector(ts,n)
##
## Return true if ts is a subset of [0,n).
##
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Misc

function b = isTargetVector(ts,n)
  b = (min(ts) >= 0 ) && (max(ts) < n) && isequal(sort(ts),unique(ts));
endfunction

%!test
%! assert(isTargetVector([0:3],4))
%! assert(!isTargetVector([0:3],2))
%! assert(isTargetVector([1:3],4))
%! assert(isTargetVector([0:2],4))
%! assert(isTargetVector([3:-1:0],4))
%! assert(isTargetVector([2,0],4))

