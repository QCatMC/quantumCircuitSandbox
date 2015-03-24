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
## @deftypefn {Function File} {} maxdepth {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function d = maxdepth(g)

  childMax = zeros(length(g.seq),1);
  for k = 1:length(g.seq)
    childMax(k) = maxdepth(g.seq{k});
  endfor
  d = 1 + max(childMax);

endfunction

%!test
%! a = @seq({@single("X",1)});
%! b = @seq({@cNot(3,5),a});
%! c = @seq({b,a,b,@meas()});
%! assert(maxdepth(a),1);
%! assert(maxdepth(b),2);
%! assert(maxdepth(c),3);
%! assert(maxdepth(@seq({}),1));