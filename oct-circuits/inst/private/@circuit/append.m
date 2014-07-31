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

## Usage: c = buildCircuit(args)
##
## construct a quantum circuit. The args can be a circuit descriptor, 
## a descriptor and the number of bits, or two or more circuit object.  In the
## first case, the number of bits is the minimum number allowabled by
## the circuit specification.  IN the second, extra bits can be added
## above the minimum number.  The case of two or more circuits, the
## circuits are appended to one another in the order they were given.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function C = append(cir,varargin )
  if( nargin == 0 )
    error("append: too few arguments. Need at least 1 circuit.");
  endif
  
  C = cir;
  for k = 1:length(varargin)
    curr = varargin{k};

    C.bits = max(C.bits,get(curr,"bits"))

    C.seq = append(C.seq,get(curr,"seq"));

    C.maxDepth = max(C.maxDepth,get(curr,"maxDepth"));

    currSteps = get(curr.stepsAt);
    C.stepsAt = padarray(C.stepsAt,C.maxDepth) + padarray(currSteps,C.maxDepth);
  endfor

endfunction
