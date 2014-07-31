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

## usage: b = isCircDescriptor(circArr)
##
## Checks if circArr is a valid circuit description cell array and returns
## true if it is.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function b = isCircDescriptor(circArr)

  b = true;
  
  if( !iscell(circArr) )  #wrong container type
    b = false; return;
  elseif( isGateDescriptor(circArr) )
    return;
  else
    b = cellfun(@isCircDescriptor,circArr);       
  endif

end

%!test
%! C = {{"H",3},{"H",2},{"CNot",1,5}};
%! assert(validCirc(C));
%! C = {{"H",3},{"H",-1},{"CNot",1,5}};
%! assert(!validCirc(C));
%! C = {{"H",3},{"H",2},{"CNot",5,5}};
%! assert(!validCirc(C));
%! C = {{"H",3},{"Measure"},{"H",2},{"CNot",1,5}};
%! assert(validCirc(C));
%! C = {{"H",3},{"Q",2},{"CNot",1,5}};
%! assert(!validCirc(C));
%! C = {{"H",3},{"H",2},{"CNot",5}};
%! assert(!validCirc(C));
%! C = {{"H",3},{"H",2,4},{"CNot",1,5}};
%! assert(!validCirc(C));

function b = isGateDescriptor(circArr)
  b = true;
  if( !validOp(circArr{1}) )
    b = false; return;
  else
    switch( circArr{1} )
      case "Measure"
	if( length(circArr) != 2 )
	  b = false;return;
	elseif( !isTargetVector(circArr{2}) )
	  b=false; return;
	endif

    endswitch

endfunction
