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
## @deftypefn {Function File} {} stepsat {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function s = stepsat(g,d)

  if( d == 1 )
    s = length(g.seq);
  else
    sarr = zeros(length(g.seq),1);
    for idx = 1:length(g.seq)
      sarr(idx) = stepsat(g.seq{idx},d-1);
    endfor
    s = sum(sarr);
  endif
endfunction

%!test
%! A = @seq({@single("H",1),@cNot(2,1),...
%!               @meas([1,2,5])});
%! assert(stepsat(A,1),3);
%! assert(stepsat(A,2),3);
%! B = @seq({@single("Z",2),A});
%! assert(stepsat(B,1),2);
%! assert(stepsat(B,2),4);
