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

## Usage: C = buildcircuit(desc,eta,varargin)
##
## Used to construct a QASM quantum circuit object from a QIASM 
## circuit descriptor. The QASM circuit will approximate the specified
## QIASM to within an error less than eta.
## 
## Where cir is a circuit descriptor: buildCircuit(cir) will construct
## a circuit with precision eta = 2^-7 and with a qubit size
## determiend by the max qubit target, buildCircuit(cir,eta) constructs the
## circuit whose size is determined by the maximum qubit target of
## cir and with user specified precision eta,buildCircuit(cir,eta,size) will 
## construct a circuit of size 'size' and precision eta. 
## All oct-circuit circuits should be constructed via this function
## and not by explicit usage of the QIASM and QASM object constructors. 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function C = buildCircuit(desc,eta=2^(-7),varargin )

  nargs = length( varargin );

  ## 1-2 arg --> Descriptor only or Descriptor+Size
  if( iscell(desc) && isreal(eta) && isscalar(eta) && eta > 0 && eta < 1)

    ## build QIASM circuit with size derived from targets
    QIASMcir = @QIASMcircuit(parseQIASMDesc(desc));     

    ## compile to QASM
    C = compile(QIASMcir,eta);

    ## change size if needed and possible
    if( length(varargin) == 1 )
      ## check size
      size = varargin{1};
      if( !isscalar(size) || !(floor(size) == ceil(size)) || size <= 0  )
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

## accuracy and correctness of parse and compile functions are tested
##  in those functions. These tests just cover error checking
%!test
%! fail('buildCircuit(5,5,5)');
%! fail('buildCircuit({{"H",0}},5,5)');
%! fail('buildCircuit({{"H",0}},0,5)');
%! fail('buildCircuit({{"H",0}},-2,5)');
%! fail('buildCircuit({{"H",0}},0.5,0)');
%! fail('buildCircuit({{"H",0}},0.5,-2)');
%! fail('buildCircuit({{"H",3}},0.5,1)');
%! assert(isa(buildCircuit({{"H",0}}),"QASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},0.5),"QASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},0.5,2),"QASMcircuit"));
