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
## returns equivalent @QIASMcNot when @QIRcU is cNot, otherwise
## returns an equivalent @QIASMseq 
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR
 

function q = compile(this)

  if( length(this.op) == 1 && strcmp(this.op{1},"X"))
    q = @QASMcNot(this.tar,this.ctrl);
  else
    ## Todo
    q = @QIASMseq({});
  endif

endfunction


