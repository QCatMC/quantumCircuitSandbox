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
## returns true if @QIASMseq this is equivalent to other.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM

function b = eq(this,other)
  b = false;
  if( isa(other,"QIASMseq") )
    othseq = get(other,"seq");
    if( length(this.seq) == length(othseq) )
      eqvals = cellfun(@eq,this.seq,get(other,"seq"));
      if( sum(eqvals) == length(this.seq) )
	b = true;
      endif
    endif
  endif
endfunction


%!test
%! assert(false);
%! a = @seqNode({@QIASMsingle("H",1),@QIASMcNot(0,1)});
%! b = @seqNode({@QIASMsingle("H",1),@QIASMcNot(0,1)});
%! c = @seqNode({@QIASMsingle("H",1)});
%! d = @seqNode({@QIASMsingle("H",1),@QIASMcNot(0,1),@seqNode({@QIASMmeasure()})});
%! e = @seqNode({@QIASMsingle("H",1),@QIASMcNot(0,1),@seqNode({@QIASMmeasure()})});
%! assert(eq(a,a));
%! assert(eq(a,b));
%! assert(eq(d,e));
%! assert(!eq(a,c));
%! assert(!eq(a,d));
