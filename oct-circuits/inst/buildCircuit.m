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

function C = buildCircuit( varargin )

  nargs = length( varargin );

  ## 1 arg --> Descriptor only
  if( nargs == 1 && validCirc(varargin{1}) )
    C = @circuit(varargin{1},minCircSize(varargin{1}));    
  ## 2 arg case 1: Descriptor + number of bits
  elseif( nargs == 2 && isinteger(varargin{2}) && \
	  validCirc(varargin{2}) )
    ## check size
    if( varargin{2} < minCircSize(varargin{1}) )
      error("Bad circuit size given");
    endif

    C = @circuit(varargin{1},varargin{2});
	
  ## 2+ arg circuit append case
  elseif( nargs >= 2 )  #
    for k = 1:nargs
      if( !isa(c,"circuit") )
	error("Expecting 2 or more circuits. Found something else.");
      endif
    endfor

    ## append circuits
    C = varargin{1};
    for k = 2:nargs
      C = append(C,varargin{k});
    endfor

  else
    print_usage();
  endif
 
endfunction
