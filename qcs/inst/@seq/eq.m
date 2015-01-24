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
## @deftypefn {Function File} {} eq {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function b = eq(this,other)
  b = false;
  if( isa(other,"seq") )
    othseq = other.seq;
    if( length(this.seq) == length(othseq) )
      for k = 1:length(this.seq)
        if( !eq(this.seq{k},other.seq{k}) )
          b = false;
          return;
        endif
      endfor
      b=true;
    endif
  endif
endfunction

%!test
%! a = @seq({@single("H",1),@cNot(0,1)});
%! b = @seq({@single("H",1),@cNot(0,1)});
%! c = @seq({@single("H",1)});
%! d = @seq({@single("H",1),@cNot(0,1),@seq({@meas()})});
%! e = @seq({@single("H",1),@cNot(0,1),@seq({@meas()})});
%! assert(eq(a,a));
%! assert(eq(a,b));
%! assert(eq(d,e));
%! assert(!eq(a,c));
%! assert(!eq(a,d));
