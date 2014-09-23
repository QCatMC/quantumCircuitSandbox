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

## usage: b = QIASMvalidOp(OpStr)
##
## Checks if OpStr is a valid operation descriptor string for QIASM and returns
## true if it is.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function b = QIASMvalidOp(OpStr)

  if( !ischar(OpStr) )
    b = false;
  else
    if( QASMvalidOp(OpStr) )
      b = true;
    else
      switch (OpStr)
	case { "PhAmp","ZYZ","Rn" }
	  b = true; 
	otherwise
	  b = false; 
      endswitch
    endif
  endif

end

%!test
%! assert(!validOp("dog"));
%! assert(validOp("Y"));
%! assert(validOp("H"));
%! assert(validOp("X"));
%! assert(validOp("CNot"));
