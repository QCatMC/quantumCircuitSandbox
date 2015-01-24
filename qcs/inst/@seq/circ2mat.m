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
## @deftypefn {Function File} {} circ2mat {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function U = circ2mat(g,n)

  U = speye(2^n);
  for k = 1:length(g.seq)
    U = circ2mat(g.seq{k},n)*U;
  endfor

endfunction

%!test
%! a = @seq({@single("H",0),@single("H",0)});
%! b = @seq({@single("H",0),@single("H",1)});
%! c = @seq({@single("H",0),@seq({@single("H",1)})});
%! assert(isequal(H*H,circ2mat(a,1)));
%! assert(isequal(tensor(H,H),circ2mat(b,2)));
%! assert(isequal(tensor(H,H),circ2mat(c,2)));
