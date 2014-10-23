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
## returns equivalent @QIASMsingle to @QIRsingle this when the operator
## targets a single qubit. Otherwise a sequence of @QIASMsingles is returned
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR
 

function q = compile(this)

  if(length(this.tars) == 1)
    q = @QIASMsingle(this.name,this.tars(1),this.params);
  else #if( length(this.tars) > 1 )
    qseq = cell(1,length(this.tars));
    for k = 1:length(qseq)
      qseq{k} = @QIASMsingle(this.name,this.tars(k),this.params);
    endfor
    q = @QIASMseq(qseq);
  endif

endfunction
