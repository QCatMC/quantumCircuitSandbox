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
## @deftypefn {Function File} {} get {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function s = get(cir,f)

  if (nargin == 1)
    s.bits = cir.bits;
    s.seq = cir.seq;
    s.maxndepth = cir.maxndepth;
    s.stepsat = cir.stepsat;
    s.tars = cir.tars;
  elseif (nargin == 2)
    if ( ischar(f) )
      switch(f)
	case "seq"
	  s = cir.seq;
	case "bits"
	  s = cir.bits;
	case "maxndepth"
	  s = cir.maxndepth;
	case "stepsat"
	  s = cir.stepsat;
	case "tars"
	  s = cir.tars;
	otherwise
	  error("get: invalid property %s",f);
      endswitch
    else
      error("get: expecting the property to be a string");
    endif
  else
    print_usage();
  endif

endfunction

%!test
%! c = @circuit(@seq({@single("H",0)}),1,1,[1],[0]);
%! assert(eq(get(c,"seq"),@seq({@single("H",0)})));
%! assert(get(c,"bits"),1);
%! assert(get(c,"maxndepth"),1);
%! assert(isequal(get(c,"stepsat"),[1]));
%! assert(isequal(get(c,"tars"),[0]));
%! s.seq = @seq({@single("H",0)});
%! s.bits=1;
%! s.tars = [0];
%! s.stepsat = [1];
%! s.maxndepth = 1;
%! assert(isequal(get(c),s));
