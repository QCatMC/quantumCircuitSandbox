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

## Usage: C = buildCircuit(args)
##
## Used to construct a quantum circuit from a circuit descriptor. 
## 
## Where cir is a circuit descriptor, buildCircuit(cir) constructs the
## circuit whose size is determined by the maximum qubit target of
## cir. Alternatively, buildCircuit(cir,size) will construct a circuit
## of size 'size'. All oct-circuit circuits should be constructed via
## this function and not by explicit usage of the @circuit object
## hierarchy constructors. See package documentation for a discussion
## of the oct-circuit circuit descriptor syntax. 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function C = buildCircuit( varargin )

  nargs = length( varargin );

  ## 1-2 arg --> Descriptor only or Descriptor+Size
  if( nargs <= 2 && iscell(varargin{1}) )
    ## build circuit with size inferred from targets
    cir = parseDescriptor(varargin{1});
    C = @circuit(cir);
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
%! d = {{{"H",1},{"H",0}},{"CNot",1,0},{"H",1},{"Measure",0:1}};
%! C1 = buildCircuit(d);
%! assert(true);
