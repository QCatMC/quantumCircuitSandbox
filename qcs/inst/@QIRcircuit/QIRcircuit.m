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

## Usage: c = @QIRcircuit(seq,n)
##
## Users should use the buildCircuit function to construct
## oct-circuits rather than expicitly constuct the object themselves.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function c = QIRcircuit(cNode,n)

  if(nargin == 0 )
    c.bits = 0;
    c.seq = @QIRseq({});
  elseif(nargin == 1 || nargin == 2)
    c.bits = 0;
    c.seq = cNode;
    if( nargin == 2 )
      c.bits = n;
    else
      c.bits = 1+max(collectTars(c.seq));
    endif
  endif
  
  c = class(c,"QIRcircuit");

endfunction


