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

## Usage: g = get(sg, f)
##
## QIASMsingle field selector 


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM

function s = get(sg,f)

  if (nargin == 1)
    s.name = get(sg.sing,"name");
    s.tar = get(sg.sing,"tar");
    s.params = get(sg.sing,"params");
  elseif (nargin == 2)
    if ( ischar(f) )
      switch(f)
	case "name"
	  s = get(sg.sing,"name");
	case "tar"
	  s = get(sg.sing,"tar");
	case "params"
	  s= get(sg.sing,"params");
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
%! a = @QIASMsingle("X",0);
%! b = @QIASMsingle("H",1);
%! c = @QIASMsingle("Z",2);
%! assert(get(a,"tar"),0);
%! assert(get(b,"tar"),1);
%! assert(get(c,"tar"),2);
%! assert(get(c,"name"),"Z");
%! assert(get(a,"name"),"X");
%! as.name = "X";
%! as.tar = 0;
%! assert(get(a),as);
