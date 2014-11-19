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

## Usage: s = get(cir, f)
##
## circuit field selector 


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QASM

function s = get(circ,f)

  if (nargin == 1)
    s.bits = get(circ.cir,"bits");
    s.seq = get(circ.cir, "seq");
    s.maxDepth = get(circ.cir,"maxDepth");
    s.stepsAt = get(circ.cir,"stepsAt");
    s.tars = get(circ.cir,"tars");
  elseif (nargin == 2)
    if ( ischar(f) )
      switch(f)
	case "seq"
	  s = get(circ.cir,"seq");
	case "bits"
	  s = get(circ.cir,"bits");
	case "maxDepth"
	  s = get(circ.cir,"maxDepth");
	case "stepsAt"
	  s = get(circ.cir,"stepsAt");
	case "tars"
	  s = get(circ.cir,"tars");
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
