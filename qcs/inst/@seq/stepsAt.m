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

## Usage: s = stepsAt(g,d)
##
##  used to compute number of steps at depth d of a circuit. 
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function s = stepsAt(g,d)
  if( d == 1 )
    s = length(g.seq);
  else
    sarr = zeros(length(g.seq),1);
    for idx = 1:length(g.seq)
      sarr(idx) = stepsAt(g.seq{idx},d-1);
    endfor
    s = sum(sarr);
  endif
endfunction

%!test
%! A = @seq({@single("H",1),@cNot(2,1),...
%!               @measure([1,2,5])});
%! assert(stepsAt(A,1),3);
%! assert(stepsAt(A,2),3);
%! B = @seq({@single("Z",2),A});
%! assert(stepsAt(B,1),2);
%! assert(stepsAt(B,2),4);
