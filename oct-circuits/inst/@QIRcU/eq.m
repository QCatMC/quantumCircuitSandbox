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
## returns true if @QIRcU this is equivalent to other.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR
 

function b = eq(this,other)

  b=false;
  if( !isa(other,"QIRcU") )
    b=false;
  elseif( eq(this.ctrl,get(other,"ctrl")) && ...
	  eq(this.tar,get(other,"tar")) && ...
	  isequal(this,tar.op,get(other,"op")) )
    b=true; 
  else
    b=false;
  endif

endfunction


%!test
%! a = @QIRcU(1,2,{"X"});
%! b = @QIRcU(2,1,{"X"});
%! c = @QIRcU(1,2,{"X"});
%! d = @QIRcU(3,4,{"X"});
%! assert(eq(a,a));
%! assert(eq(a,c));
%! assert(!eq(a,b));
%! assert(!eq(a,d));

## test for C-QIASMsingle 
%!test
%! assert(false);
