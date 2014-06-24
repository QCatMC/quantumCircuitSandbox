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

## usage: b = validCirc(circArr)
##
## Checks if circArr is a valid circuit description cell array and returns
## true if it is.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function b = validCirc(circArr)

  b = true;
  
  if( !iscell(circArr) )  #wrong container type
    b = false; return;
  else # right container. check each field
    for k = 1:length(circArr);
      curr = circArr{k}; #current field
      if( !iscell(curr) ) #not a cell array?
	b = false; return;
      elseif( length(curr) > 3 || length(curr) < 1 ) #wrong length?
	b = false; return;
      endif

      ## it's a cell and the has a length of 1,2, or 3
      ## measure Op (length 1 cell)?
      if( length(curr) == 1)
	if( !strcmp(curr{1},"Measure") )
	  b=false; return;
	endif
      ## unconditional,single qubit Op (length 2 cell)?
      elseif( length(curr) == 2 )
	## totally wrong in both fields 
	if( !validOp(curr{1}) || curr{2} < 0 )
	  b=false; return;
	endif
	## no CNot
	if( strcmp(curr{1},"CNot") )
	  b=false; return;
	endif
	
      ## Conditional Not Op (length 3 cell)?
      elseif(length(curr) == 3) 
	## way off
	if( !strcmp(curr{1},"CNot") || curr{2} < 0 || curr{3} < 0 )
	  b=false; return;
	endif
	## target == control
	if( curr{2} == curr{3} )
	  b = false; return;
	endif	
      endif
    
    ## it's a valid cell, keep going.
    endfor
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
