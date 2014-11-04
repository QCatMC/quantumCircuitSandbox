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
## returns equivalent @QIASMseq to @QIRtoffoli
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR
 

function q = compile(this)
  t = this.tar;
  c1 = this.ctrls(1);
  c2 = this.ctrls(2);
  
  ## Nielsen and Chuang pg 182
  q = @QIASMseq({@QIASMsingle("H",t),...
		 @QIASMcNot(t,c2),...
		 @QIASMsingle("T'",t),...
		 @QIASMcNot(t,c1),...
		 @QIASMsingle("T",t),...
		 @QIASMcNot(t,c2),...
		 @QIASMsingle("T'",t),...
		 @QIASMcNot(t,c1),...
		 @QIASMsingle("T'",c2),@QIASMsingle("T",t),...
		 @QIASMcNot(c2,c1),@QIASMsingle("H",t),...
		 @QIASMsingle("T'",c1),...
		 @QIASMcNot(c2,c1),...
		 @QIASMsingle("T",c1),@QIASMsingle("S",c2)});

endfunction
