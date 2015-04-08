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

## -*- texinfo -*-
## @deftypefn {Function File} {@var{C} =} horzcat (@var{A},@var{B},...)
##
## Concatenate circuits or gates to the end of circuit @var{C}.
##
## Concatenating gates to @var{C} adds the gates at ndepth 1 of
## @var{c}. Contenating a circuit places the concatenated circuit
## as a nested sub-circuit of @var{C}.
##
## @seealso{QIR}
##
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function C = horzcat(this,varargin)
  ## empty circuits start with empty cell array
  ## non-empty circuits start with their seq cell array
  if( length(get(get(this,"seq"),"seq")) == 0 )
    seq = cell();
  else
    seq = get(get(this,"seq"),"seq");
  endif

  ## for each gate
  for g = varargin
    ##  unpack the singleton array selected by for
    other = g{1};
    ## check other's type
    switch(class(other))
      case {"QIRsingle","QIRswap","QIRtoffoli","QIRfredkin","QIRcU", ...
      "QIRmeasure" }
         ## append gates
         seq{end+1} = other;
      case "QIRcircuit"
         ## get the sequence cell array of the circuit
         s = get(get(other,"seq"),"seq");
         ## ignore empty circuits
         ## for non-empty circuits, we'll create a new nesting ndepth
         ## by appending other's seq
         ## when this is empty, nest other's seq.
         if( length(s) > 0 && length(seq) > 0 )
            seq{end+1} =  get(other,"seq");
          elseif( length(seq) == 0 )
            seq = {@QIRseq(s)};
         endif

      otherwise
         error("Invalid gate type %s encountered",class(other));
    endswitch
  endfor

  ## catch empty-empty concatenations
  if( length(seq) == 0 )
    ## somebody concatenated empty circuits.. so give them empty.
    C = @QIRcircuit();
  else
    C = @QIRcircuit(@QIRseq(seq));
  endif
endfunction

%!test
%! a = @QIRseq({@QIRsingle("H",0), @QIRcU(0,1,{"X"}), @QIRswap(2,1), ...
%!              @QIRfredkin([0,1],2), @QIRmeasure(0:4), ...
%!              @QIRtoffoli(2,[0,1])  });
%! A = @QIRcircuit(a);
%! assert(eq(A,[A,QIR]));
%! C = @QIRcircuit(@QIRseq({a}));
%! assert(eq(C,[QIR,A]));
%! b = @QIRseq({@QIRsingle("H",0), @QIRcU(0,1,{"X"}), @QIRswap(2,1), ...
%!              @QIRfredkin([0,1],2), @QIRmeasure(0:4), ...
%!              @QIRtoffoli(2,[0,1]),a});
%! B = @QIRcircuit(b);
%! assert(eq(B,[A,A]));
