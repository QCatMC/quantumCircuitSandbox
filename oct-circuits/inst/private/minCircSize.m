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

## usage: n = minCircSize(circArr)
##
## Determines the minimum circuit size, in qubits, for the circuit described by
## the circArr.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function n = minCircSize(circArr)
  n=-1;
  for k = 1:length(circArr)
    n = max(n,circArr{k}{2});
    if (length(circArr{k}) == 3)
       n = max(n,circArr{k}{3});
    endif
  endfor
  n = n+1;
endfunction

%!test
%! C = {{"H",3},{"H",2},{"CNot",1,5}};
%! assert(minCircSize(C),6);
%! C = {{"H",0},{"H",2},{"CNot",1,0}};
%! assert(minCircSize(C),3);
%! C = {};
%! assert(minCircSize(C),0);
