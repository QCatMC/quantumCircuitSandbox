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
  if( nargs == 1 && iscell(varargin{1}) && iscell(varargin{1}{1}) )
    cir = parseDescriptor(varargin{1});
    C = @circuit(cir,minCircSize(varargin{1}));    
  ## 2 arg case 1: Descriptor + number of bits
  elseif( nargs == 2 && iscell(varargin{1}) && iscell(varargin{1}{1}) )

    minsize = minCircSize(varargin{1});
    ## check size
    size = varargin{2};
    if( !isNat(size) || size == 0  )
      error(" circuit size must be a strictly positive integer ");
    elseif( size < minsize )
      error(" specified size too small for given circuit ");
    endif    

    cir = parseDescriptor(varargin{1});
    C = @circuit(cir,size);
	
  ## 2+ arg circuit append case
  elseif( nargs >= 2 )  #
    for k = 1:nargs
      if( !isa(varargin{k},"circuit") )
	error("Expecting 2 or more circuits. Found something else.");
      endif
    endfor

    ## append circuits
    C = append(varargin)

  else
    print_usage();
  endif
 
endfunction
