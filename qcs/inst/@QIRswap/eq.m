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
## returns true if @QIRswap is equivalent to other.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR


function b = eq(this,other)
  b = isa(other,"QIRswap") && ...
       this.tar1 == other.tar1 && ...
       this.tar2 == other.tar2;
endfunction

%!test
%! a = @QIRswap(0,1);
%! b = @QIRswap(0,1);
%! c = @QIRswap(0,2);
%! d = @QIRswap(2,1);
%! e = @QIRsingle("H",0);
%! assert(eq(a,a));
%! assert(eq(a,b));
%! assert(!eq(a,c));
%! assert(!eq(a,d));
%! assert(!eq(a,e));
