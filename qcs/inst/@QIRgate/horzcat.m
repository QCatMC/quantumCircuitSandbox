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

## Usage: C = horzcat(this,other)
##
## returns @QIRcircuit C = [a,b]
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function C = horzcat(this,varargin)
  ## build cell array for sequence starting with this
  seq = {this};

  ## for each argument
  for g = varargin
    ## g is a singleton cell array, get the gate/circuit
    other = g{1};
    ## result differs by gate type
    switch(class(other))
      ## gates get appened to the sequence
      case {"QIRsingle","QIRswap","QIRccU","QIRfredkin","QIRcU", ...
      "QIRmeasure" }
         seq{end+1} = other;
      ## when a circuit is encountered, add seq to the seq of that
      ## circuit.
      case "QIRcircuit"
          ## get the cell array of the circuit sequence
          s = get(get(other,"seq"),"seq");
          ## combine sequences when circuit is non-empty
          ## empty circuit sequecnes are ignored
          ##  so [a,QIR] and [QIR,a] will produce the circuit
          ##   containing just a.
          if( length(s) > 0 )
             seq = {seq{:},s{:}};
          endif

      otherwise
         error("Invalid gate type %s encountered",class(other));
    endswitch
  endfor
  ## resultant circuit is constructed from seq.  Circuit attributes
  ## are computed by the circuit constructor

  C = @QIRcircuit(@QIRseq(seq));
endfunction

%!test
%! a = @QIRseq({@QIRsingle("H",0), @QIRcU(0,1,{"X"}), @QIRswap(2,1), ...
%!              @QIRfredkin([0,1],2), @QIRmeasure(0:4), ...
%!              @QIRccU(2,[0,1],{"X"})  });
%! A = @QIRcircuit(a);
%! B = [@QIRsingle("H",0), @QIRcU(0,1,{"X"}), @QIRswap(2,1), ...
%!              @QIRfredkin([0,1],2), @QIRmeasure(0:4), ...
%!              @QIRccU(2,[0,1],{"X"}), @QIRcircuit() ];
%! assert(eq(A,B));
%! B = [@QIR("H",0),A];
%! a = @QIRseq({@QIRsingle("H",0),@QIRsingle("H",0), @QIRcU(0,1,{"X"}),  ...
%!              @QIRswap(2,1), @QIRfredkin([0,1],2), @QIRmeasure(0:4), ...
%!              @QIRccU(2,[0,1],{"X"})  });
%! A = @QIRcircuit(a);
%! assert(eq(A,B));
