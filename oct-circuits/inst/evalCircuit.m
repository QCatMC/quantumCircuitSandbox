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
	## complete measure
	if(length(circ{k}) == 1)
	  V = stdMeasure(V);
	## partial measure
	else
	  V = stdMeasure(V,circ{k}{2});
	endif
      else
	V = applyOp(V,getOp(circ{k}{1}),circ{k}{2},n);
      endif
  endfor

endfunction

%!test
%! bal_id = {{"H",1},{"H",0},{"CNot",0,1},{"H",1},{"Measure"}};
%! ts = 0:length(bal_id)-1;
%! res = zeros(4,length(ts));
%! for k = ts
%!   res(:,k+1) = evalCircuit(1,bal_id,2,k);
%! endfor
%! expt =  transpose( [0,1,0,0; ...
%!                    0,sqrt(1/2),0,sqrt(1/2); ...
%!                    1/2,-1/2,1/2,-1/2; ...
%!                    1/2,-1/2,-1/2,1/2; ...
%!                    0,0,sqrt(1/2),-sqrt(1/2)] );
%! assert(expt,res,0.0000001);

%!test
%! const_one = {{"H",1},{"H",0},{"X",0},{"H",1},{"Measure"}};        
%! ts = 0:length(const_one)-1;
%! res = zeros(4,length(ts));
%! for k = ts
%!   res(:,k+1) = evalCircuit(1,const_one,2,k);
%! endfor
%! expt =  transpose( [0,1,0,0; ...
%!                    0,sqrt(1/2),0,sqrt(1/2); ...
%!                    1/2,-1/2,1/2,-1/2; ...
%!                    -1/2,1/2,-1/2,1/2; ...
%!                    -sqrt(1/2),sqrt(1/2),0,0] );
%! assert(expt,res,0.0000001);

## Test with partial measurement
