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

## Usage: q = compile(this)
##
## returns equivalent @QIASMseq to @QIRseq this.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR
 

function q = compile(this)
	 
  s = cell(length(this.seq),1);
  for k = 1:length(s)
    s{k} = compile(this.seq{k});
  endfor

  q = @QIASMseq(s);		       

endfunction

%!test
%! c = {@QIRsingle("H",0),@QIRsingle("H",1)};
%! C = @QIRseq(c,@QIRseq(c));
%! r = {@QIASMsingle("H",0),@QIASMsingle("H",1)};
%! R = @QIASMseq(r,@QIASMseq(r));
%! assert(eq(compile(C),R));



