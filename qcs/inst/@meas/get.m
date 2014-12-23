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

## Usage: g = get(mg, f)
##
## @meas field selector

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function s = get(mg,f)

  if (nargin == 1)
    s.tar = mg.tar;
  elseif (nargin == 2 )
    if ( ischar(f) )
      switch(f)
	case "tar"
	s = mg.tar;
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
%! a = @meas();
%! b = @meas(1:3);
%! assert([],get(a,"tar"));
%! assert([1,2,3],get(b,"tar"));
%! bs.tar = [1,2,3];
%! assert(bs,get(b));
