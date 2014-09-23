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

## usage: b = validOp(OpStr)
##
## Checks if OpStr is a valid operation descriptor string and returns
## true if it is.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function b = validOp(OpStr)

  if( !ischar(OpStr) )
    b = false;
  else
    switch (OpStr)
      case {"I","X","Z","Y","H","T","S", ...
	    "I'","X'","Z'","Y'","H'","T'","S'",...
	    "CNot","Measure"}
	b = true; 
      otherwise
	b = false; 
    endswitch
  endif

end

%!test
%! assert(!validOp("dog"));
%! assert(validOp("Y"));
%! assert(validOp("H"));
%! assert(validOp("X"));
%! assert(validOp("CNot"));
