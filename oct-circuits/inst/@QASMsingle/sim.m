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

## Usage: [y,t] = sim(gate,in,bits,currd,dlim,currt,tlim)
## 
##  simulate the action of a @singleGate 'gate' on pure state
##  'in' in a system of size 'bits'.  The current simulation depth is
##  currd and dlim is the user specified simulation depth limit.
##  Similarly, currt is the current simulation time step (w.r.t to
##  dlim) and tlim is the user specified number of steps to simulate.
##  The simulation returns two results, the pure state y that results
##  from the operator and the current time step t. 
##

## Author: Logan Mayfield
## Keyword: QASM

function [y,t] = sim(gate,in,bits,currd,dlim,currt,tlim)

  y = applyOp(in,getOp(gate.name),gate.tar,bits);
  if( currd <= dlim )
    t = currt+1;
  elseif( currd > dlim )
    t = currt;
  endif    

endfunction

## usage: U = getOp(OpStr)
##
## Convert from operator name to matrix
function U = getOp(OpStr)

  switch (OpStr)
    case {"I","I'"}
      U=Iop;
    case {"X","X'"}
      U=X;
    case {"Z","Z'"}
      U=Z;
    case {"Y","Y'"}
      U=Y;
    case {"H","H'"}
      U=H;
    case "T"
      U=T;
    case "T'"
      U=T';
    case "S"
      U=S; 
    case "S'"
      U=S';
    otherwise
      error("Unknown Operation");
  endswitch

end

%!test
%! fail('getOp("G")');
%! fail('getOp("Measure")');
%! fail('getOp("CNot")');
%! assert(getOp("Y"),Y);
%! assert(getOp("S"),S);
