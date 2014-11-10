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
##  simulate the action of a @seqNode 'gate' on pure state
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
  [y,t] = sim(gate.seq,in,bits,currd,dlim,currt,tlim);
endfunction


## should probably do more tests here.
%!test
%! A = @QASMseq({@QASMsingle("X",0),@QASMsingle("X",1)});
%! B = @QASMseq({@QASMsingle("X",1),A});
%! ## w.r.t to B --> 2 steps @ 1, 3 @ 2+
%! in = (0:3==0)';
%! ## whole thing.. currd < dlim, t<tlim
%! assert(sim(B,in,2,1,2,0,3),double((0:3==1)'))
%! ## nothing
%! assert(sim(B,in,2,1,2,1,1,0,3),in);
%! ## currd == dlim
%! assert(sim(B,in,2,1,1,1,2),double((0:3==2)'))
%! ## 2 of three
%! assert(sim(B,in,2,1,2,1,3),double((0:3==3)'))

