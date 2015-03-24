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
## @deftypefn {Function File} {} collecttars {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function t = collecttars(this)

  t = [];
  ## collect
  for idx = 1:length(this.seq)

    subtars = collecttars(this.seq{idx});

    if( length(subtars) == 1 )
      t(end+1) = subtars;
    else
      t = [t,subtars];
    endif

  endfor
  t = unique(t);

endfunction

%!test
%! C = @seq({@single("H",2),@meas([1,4]),...
%!               @cNot(3,1),@single("X",4)});
%! assert(1:4,collecttars(C));
%! D = @seq({C,@single("Y",7)});
%! assert(isequal([1,2,3,4,7],collecttars(D)));
