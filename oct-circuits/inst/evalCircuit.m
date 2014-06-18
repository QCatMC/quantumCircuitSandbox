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
## n qubits for t steps and return the pure state that results. 
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function V = evalCircuit(in,circ,n,t=length(circ))
  V=zeros(2^n,1);

  ## initialize state
  V = stdBasis(in,n);

  ## step through circuit
  for k = 1:t
      if( strcmp(circ{k}{1},"CNot") )
	V = applyCNot(V,circ{k}{3},circ{k}{2},n);
      elseif( strcmp(circ{k}{1},"Measure") )
	V = stdMeasure(V);
      else
	V = applyOp(V,getOp(circ{k}{1}),circ{k}{2},n);
      endif
  endfor

endfunction

%!test
%! assert(true)
