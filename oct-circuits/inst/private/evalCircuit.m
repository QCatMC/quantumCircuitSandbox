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
## n qubits for steps given in t and return the pure state that results. 
## Inputs can be positive integers(0 to 2^n-1), binary representations
## of integers (n bits) as vectors, or a quantum pure state (2^n unit
## column vector). The time steps t should be sequential and increasing.

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function V = evalCircuit(in,circ,n,t=1:length(circ))
  V=zeros(2^n,1);

  ## initialize state for non-pure-state inputs
  if( isequal(size(in),[1,1]) || (rows(in) == 1 && columns(in) == n) )
    V = stdBasis(in,n);
  ## its a pure-state
  elseif( columns(in) == 1 )
    V = in;
  endif

  ## compute if needed
  if( !isempty(t) )
    ## step through circuit
    for k = t
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
  endif

endfunction

%!test
%! bal_id = {{"H",1},{"H",0},{"CNot",0,1},{"H",1},{"Measure"}};
%! ts = 0:length(bal_id)-1;
%! res = zeros(4,length(ts));
%! for k = ts
%!   res(:,k+1) = evalCircuit(1,bal_id,2,1:k);
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
%!   res(:,k+1) = evalCircuit(1,const_one,2,1:k);
%! endfor
%! expt =  transpose( [0,1,0,0; ...
%!                    0,sqrt(1/2),0,sqrt(1/2); ...
%!                    1/2,-1/2,1/2,-1/2; ...
%!                    -1/2,1/2,-1/2,1/2; ...
%!                    -sqrt(1/2),sqrt(1/2),0,0] );
%! assert(expt,res,0.0000001);


%!test
%! const_one = {{"H",1},{"H",0},{"X",0},{"H",1},{"Measure",[1]}};        
%! res = zeros(4,1);
%! for k = 30
%!   res = evalCircuit(1,const_one,2);
%!   assert(res,sqrt(1/2)*[-1,1,0,0]',0.00000001);
%! endfor


%!test
%! const_one = {{"H",1},{"X",0},{"H",1},{"Measure"}};   
%! in = sqrt(1/2)*[1,-1,0,0]';     
%! ts = 0:length(const_one)-1;
%! res = zeros(4,length(ts));
%! for k = ts
%!   res(:,k+1) = evalCircuit(in,const_one,2,1:k);
%! endfor
%! expt =  transpose( [sqrt(1/2),-sqrt(1/2),0,0; ...
%!                     1/2,-1/2,1/2,-1/2; ...
%!                    -1/2,1/2,-1/2,1/2; ...
%!                    -sqrt(1/2),sqrt(1/2),0,0] );
%! assert(expt,res,0.0000001);


%!test
%! const_one = {{"H",1},{"H",0},{"X",0},{"H",1},{"Measure",[1]}};        
%! res = zeros(4,1);
%! in = evalCircuit(1,{{"H",1},{"H",0}},2);
%! for k = 30
%!   res = evalCircuit(in,const_one,2,3:length(const_one));
%!   assert(res,sqrt(1/2)*[-1,1,0,0]',0.00000001);
%! endfor

