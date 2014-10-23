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
## QIRswap selector


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function s = get(sg,f)

  if (nargin == 1)
    s.tar1 = sg.tar1;
    s.tar2 = sg.tar2;
  elseif (nargin == 2)
    if ( ischar(f) )
      switch(f)
	case "tar1"
	  s = sg.tar1;
	case "tar2"
	  s = sg.tar2;
	case "tars"
	  s= [min(tar1,tar2),max(tar1,tar2)];
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
%! assert(false);
