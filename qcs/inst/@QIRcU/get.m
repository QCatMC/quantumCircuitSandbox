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
## @deftypefn {Function File} {@var{s} =} get (@var{C},@var{f})
##
## Select field/property @var{f} of cU gate @var{C}
##
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function s = get(cng,f)

  if (nargin == 1)
    s.tar = cng.tar;
    s.ctrl = cng.ctrl;
    s.op = cng.op;
  elseif (nargin == 2)
    if ( ischar(f) )
      switch(f)
	case "tar"
	  s = cng.tar;
	case "ctrl"
	  s = cng.ctrl;
	case "op"
	  s = cng.op;
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
%! a = @QIRcU(0,1,{"PhAmp",[pi,pi,pi]});
%! as.tar = 0; as.ctrl =1; as.op = {"PhAmp",[pi,pi,pi]};
%! assert(isequal(get(a),as));
%! assert(get(a,"tar"),0);
%! assert(get(a,"ctrl"),1);
%! assert(isequal(get(a,"op"),as.op));
