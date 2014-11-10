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

## Usage: b = eq(this,other)
##
## returns true if @singleGate this is equivalent to other.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits
 

function b = eq(this,other)

  b=false;
  if( !isa(other,"single") )
    b=false;
  elseif( strcmp(this.name,other.name) && ...
	  this.tar == other.tar && ...
	  isequal(this.params,other.params) )
    b=true; 
  else
    b=false;
  endif

endfunction


%!test
%! a = @single("H",2);
%! b = @single("H",1);
%! c = @single("H",2);
%! assert(eq(a,a));
%! assert(eq(a,c));
%! assert(!eq(a,b));
%! assert(eq(@single("PhAmp",0,[pi,pi,pi]),...
%!           @single("PhAmp",0,[pi,pi,pi])));
          
