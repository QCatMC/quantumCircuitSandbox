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
## returns true if @QIASMcircuit this is equivalent to other.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function b = eq(this,other)
  b = isa(other,"QIASMcircuit") && ...
      this.numtoapprox == other.numtoapprox && ...
      eq(this.cir,other.cir);
endfunction


%!test
%! A = @QIASMcircuit(@QIASMseq({@QIASMsingle("H",2)}));
%! B = @QIASMcircuit(@QIASMseq({@QIASMsingle("X",2)}));
%! C = @QIASMcircuit(@QIASMseq({@QIASMsingle("H",1)}));
%! D = @QIASMcircuit(@QIASMseq({@QIASMsingle("H",2)}),4);
%! assert(!eq(A,B)); #same tars different ops
%! assert(!eq(A,C)); #
%! assert(!eq(A,D));
%!
