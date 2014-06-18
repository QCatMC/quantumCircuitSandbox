oc## Copyright (C) 2014  James Logan Mayfield
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

## usage: V = evalCircuit(in,circ,n,t)
##
## Evaluate the quantum circuit described by circ using input in with
## n qubits for t steps. This version verifies input preconditions
## prior to evaluation of the circuit.
##


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function V = checked_evalCircuit(in,circ,n,t=length(circ))
  
  # check t
  if( floor(t) != ceil(t) || t < 0)
    error("Number of steps must be a positive integer");
  elseif( t > length(circ) )
    error("Number of steps cannot exceed %d. Given %%d", ...
	  length(circ),t);
  endif

  # check circ and n
  if( !validCirc(circ) )
    error("Bad Circuit Descriptor");
  else
    minSize = minCircSize(circ);
    if( minSize < n )
      error("Given size too small for circuit.");
    endif
  endif

  # check in
  if( length(in) == 1 &&  (floor(in) != ceil(in) || in < 0 || in > 2^n) )
    error("Numeric input is not an integer or is out of bounds");
  elseif( !isBitArray(in) || length(in) > n )
    error("Array input isn't binary or is too long");
  endif

  V=evalCircuit(in,circ,n,t);
endfunction

%!test
%! assert(true)
