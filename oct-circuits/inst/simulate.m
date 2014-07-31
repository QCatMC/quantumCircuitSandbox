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

## Usage: s = simulate(cir,in,d,t)
##
## simulate the Circuit cir with input in. Simulation will carry out t
## time steps with respect to depth d. 


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function s = simulate(cir,in,d=1,t=stepsAt(cir,d))

  if( !isa(cir,"circuit") ) 
    error("simulate: First argument must be a circuit.");
  elseif( d < 1 || floor(d)!=ceil(d) )
    error("simulate: Depth must be a non-zero, positive integer.");
  elseif( t < 1 || floor(t)!=ceil(t) )
    error("simulate: Number of time steps must be a non-zero, \
positive integer.");
  endif
  
  ## check and convert input
  s0 = processIn(in,get(cir,"bits"));

  s = simulate(cir,s0);

endfunction

## checking and converting circuit input
function s = processIn(in,n)

  s = stdBasis(0,n);	 
  
  if( !vector(in) )
    error("simulate: Second argument must be a natural number, pure state \
vector, or a bit vector.");
  elseif( isscalar(in) )
    if( in < 0  || floor(in) != ceil(in) || in >= 2^(get(cir,"bits")) )
      error("simulate: Scalar input must be a natural number in \
[0,|cir|)");
    else
      s = stdBasis(in,n);
    endif
  elseif( length(in) == n && isBitArray(in) )
    s = stdBasis(in,n);
  elseif( length(in) == 2^n && sum(in==0) == (2^n-1) && sum(in==1) == 1)
    s = in;
  else
    error("simulate: circuit input must be a state vector or bit \
vector. Got some other vector.");
  endif

endfunction
