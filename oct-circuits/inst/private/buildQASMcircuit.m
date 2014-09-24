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

## Usage: C = buildQASMcircuit(args)
##
## Used to construct a QASM quantum circuit object from a circuit descriptor. 
## 
## Where cir is a circuit descriptor, buildQASMCircuit(cir) constructs the
## circuit whose size is determined by the maximum qubit target of
## cir. Alternatively, buildQASMCircuit(cir,size) will construct a circuit
## of size 'size'. All oct-circuit circuits should be constructed via
## this function and not by explicit usage of the @QASMcircuit object
## hierarchy constructors. 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function C = buildQASMcircuit( varargin )

  nargs = length( varargin );

  ## 1-2 arg --> Descriptor only or Descriptor+Size
  if( nargs <= 2 && iscell(varargin{1}) )
    ## build circuit with size inferred from targets
    cir = parseQASMDesc(varargin{1});
    C = @QASMcircuit(cir);
    ## 2 arg case 1: Descriptor + number of bits
    if( nargs == 2 )
      ## check size
      size = varargin{2};
      if( !isNat(size) || size == 0  )
	error(" circuit size must be a strictly positive integer ");
      elseif( size < get(C,"bits") )
	error(" specified size too small for given circuit ");
      else
	## change size
        C = set(C,"bits",size);
      endif
    endif
  else
    print_usage();
  endif
 
endfunction

%!test
%! assert(false);
