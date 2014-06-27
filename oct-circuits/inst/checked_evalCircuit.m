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

## usage: V = evalCircuit(in,circ,n,t)
##
## Evaluate the quantum circuit described by circ using input in with
## n qubits for t steps. This version verifies input preconditions
## prior to evaluation of the circuit.
##


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function V = checked_evalCircuit(in,circ,n,t=1:length(circ))
  
  ## check t
  ## not a row vector
  if( length(size(t)) > 2 || columns(t) > 1 )
    error("Time step sequence must be sub-interval of [1,|circ|]" );
  ## bad singleton
  elseif ( length(t) == 1 && (t < 1 || t > length(circ) || ...
			      floor(t) != cieling(t)))
    error("Time step out of allowable range");
  ## bad sequence
  elseif( length(t) > 1 && !(isequal(diff(t),ones(1,length(t)-1)) && ...
			     min(t) > 0 && max(t) <= length(circ)))
    error("Time step range exceeds bounds of circuit");
  endif

  ## check circ and n
  if( !validCirc(circ) )
    error("Bad Circuit Descriptor");
  else
    minSize = minCircSize(circ);
    if( minSize < n )
      error("Given size too small for circuit.");
    endif
  endif

  ## check in
  if( length(in) == 1 &&  (floor(in) != ceil(in) || in < 0 || in > 2^n) )
    error("Numeric input is not an integer or is out of bounds");
  elseif( length(in) == n && !isBitArray(in) )
    error("Array input is a malformed binary vector");
  elseif( length(in) == 2^n && columns(in) == 1 && (in' * in) != 1 )
    error("Array input appears to be an unnormalized pure state vector");
  else
    error("Bad input. Not sure what's going on");
  endif

  V=evalCircuit(in,circ,n,t);
endfunction

%!test
%! C = {{"H",0},{"H",1},{"CNot",0,1},{"H",1},{"Measure"}};
%! fail('checked_evalCircuit(1,C,2,-1)');
%! fail('checked_evalCircuit(1,C,2,3.5)');
%! fail('checked_evalCircuit(1,C,2,7)');
%! fail('checked_evalCircuit(1,C,2,2:7)');
%! fail('checked_evalCircuit(1,C,2,-3:4)');
%! fail('checked_evalCircuit(1,C,2,0:7)');
%! fail('checked_evalCircuit(1,C,1)');
%! fail('checked_evalCircuit(-1,C,2)');
%! fail('checked_evalCircuit(4,C,2)');
%! fail('checked_evalCircuit([1;2;3;4],C,2)');
%! fail('checked_evalCircuit([1,2,3,4],C,2)');
%! fail('checked_evalCircuit([1;2],C,2)');
%! fail('checked_evalCircuit([1,2],C,2)');
%! fail('checked_evalCircuit(stdBasis(1,3),C,2)');

