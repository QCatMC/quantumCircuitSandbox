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
## returns equivalent @QIASMseq to @QIRfredkin
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR
 

function q = compile(this)
  c = this.ctrl;
  t1 = this.tars(1);
  t2 = this.tars(2);

  q = @QIASMseq({@QIASMcNot(t1,t2),...
		 ## Toffoli(t2,[c,t1]) 
		 @QIASMsingle("H",t2),...
		 @QIASMcNot(t2,t1),...
		 @QIASMsingle("T'",t2),...
		 @QIASMcNot(t2,c),...
		 @QIASMsingle("T",t2),...
		 @QIASMcNot(t2,t1),...
		 @QIASMsingle("T'",t2),...
		 @QIASMcNot(t2,c),...
		 @QIASMsingle("T",t1),@QIASMsingle("T",t2),...
		 @QIASMcNot(c,t1),@QIASMsingle("H",t2),...
		 @QIASMsingle("T",c),@QIASMsingle("T'",t1),...
		 @QIASMcNot(c,t1),...
		 ## end Toffoli
		 @QIASMcNot(t1,t2)});

endfunction