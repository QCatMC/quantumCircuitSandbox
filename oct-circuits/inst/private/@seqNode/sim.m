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

## Usage: y = simulate(seq,in,bits,currd,dlim,currt,tlim)
## 
##  simulate the action of single qubit operation gate on pure state
##  in in an n bits system
## 

## Author: Logan Mayfield
## Keyword: Circuits

function [y,t] = sim(gate,in,bits,currd,dlim,currt,tlim)

  y = in; 
  t = currt;
  
  if( currt <= tlim )
    ## treat each element of this seq as an atomic unit  
    if( currd == dlim )
      ## steps simulated from this sequence
      local_steps = min(length(gate.seq),(tlim-currt));
      
      for k = 1:local_steps
	[y,t] = sim(gate.seq(k),y,bits,currd,dlim,t,tlim);
      endfor
      
    else( currd < dlim )
      ## simulate each local step until step limit is reached
      k = 1;
      while( t <= tlim )
	[y,t] = sim(gate.seq(k),y,bits,currd+1,dlim,t,tlim);
      endwhile

    endif  
  endif

endfunction

