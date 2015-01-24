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

function s = get(sg,f)

  if (nargin == 1)
    s.name = sg.name;
    s.tar = sg.tar;
    s.params = sg.params;
  elseif (nargin == 2)
    if ( ischar(f) )
      switch(f)
	case "name"
	  s = sg.name;
	case "tar"
	  s = sg.tar;
	case "params"
	  s= sg.params;
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
%! a = @single("X",0);
%! b = @single("H",1);
%! c = @single("Z",2);
%! d = @single("PhAmp",0,pi/3*ones(1,4));
%! assert(get(a,"tar"),0);
%! assert(get(b,"tar"),1);
%! assert(get(c,"tar"),2);
%! assert(get(c,"name"),"Z");
%! assert(get(a,"name"),"X");
%! assert(isequal(get(d,"params"),[pi/3,pi/3,pi/3,pi/3]))
%! as.name = "X";
%! as.tar = 0;
%! as.params = [];
%! assert(get(a),as);
