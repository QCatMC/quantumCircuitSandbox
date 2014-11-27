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
## returns true if @QIRsingle this is equivalent to other.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR


function b = eq(this,other)
  b = isa(other,"QIRsingle") && ...
      strcmp(this.name,other.name) && ...
      isequal(this.tars,other.tars) && ...
      isequal(this.params,other.params);
endfunction

%!test
%! a = @QIRsingle("H",2);
%! b = @QIRsingle("H",1);
%! c = @QIRsingle("H",2);
%! assert(eq(a,a));
%! assert(eq(a,c));
%! assert(!eq(a,b));
%! assert(eq(@QIRsingle("PhAmp",0,[pi,pi,pi]),...
%!           @QIRsingle("PhAmp",0,[pi,pi,pi])));
