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

## Usages: 
##   C = buildCircuit(cir)
##   C = buildCircuit(cir,eta)
##   C = buildCircuit(cir,eta,size)
##   C = buildCircuit(cir,eta,tar)
##   C = buildCircuit(cir,eta,size,tar)
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function C = buildCircuit(desc,eta=2^(-7),varargin )

  ## parse optional arguments
  [size,tar] = parseargs(varargin);

  ## validate approximation threshold eta
  if( !isreal(eta) || !isscalar(eta) || eta <= 0 || eta >= 1) 
    error("Given bad approximation error threshold eta");
  endif

  ## validate desc
  if( !iscell(desc) && !isa(desc,"QIASM") && !isa(desc,"QASM") )
    error("Given bad circuit");
  endif

  ##At this point all inputs are valid and initialized
  ##  desc is either a cell array (descriptor),  a QIASM
  ##  circuit, or a QASM circuit
  ##  eta is from (0,1)
  ##  size is a positive integer or 0 for impiled size
  ##  tar is either QASM or QIASM			

  ## check bad combos
  if( isa(desc,"QASM") && strcmp(tar,"QIASM") )
    error("Cannot decopile QASM to QIASM");
  endif

  ## workable combo
  if( isa(desc,"QASM") ) ## does nothing
    C = desc;
  else # desc or QIASM with tar either QIASM or QASM

    ## Descriptors at least get converted to QIASM
    if( iscell(desc) )
      ## build QIASM circuit with size derived from targets
      C = @QIASMcircuit(parseQIASMDesc(desc));     
    else #QIASM
      C = desc;
    endif
    
    ## if target is QASM then compile
    if( strcmp(tar,"QASM") )  
      ## compile to QASM
      C = compile(C,eta);
      
      ## change size if needed and possible
      if( size > 0 )
	if( size < get(C,"bits") )
	  error(" specified size too small for given circuit ");
	else
	  ## change size
          C = set(C,"bits",size);
	endif
      endif
  
    endif
  
  endif
  
endfunction

function [s,t] = parseargs(args)

  nargs = length( args );

  switch(nargs)
    case 0 ## defaults
      s = 0;
      t = "QASM";
    case 1 ## either or
      arg = args{1};
      if(ischar(arg) && ( strcmp("QIASM",arg) || strcmp("QASM",arg) ) )
	s = 0;
	t = arg;	
      elseif(!ischar(arg) && isscalar(arg) && isreal(arg) && floor(arg) == ceil(arg) && arg > 0)
	s = arg;
	t = "QASM";
      else
	error("Bad third argument. Expecting circuit size or build target string");
      endif
    case 2 ## size,target

      t = args{2};
      if( !ischar(t) || (!strcmp("QIASM",t) && !strcmp("QASM",t)) )
	error("Given bad build target string");
      endif

      s = args{1};
      if(!isscalar(s) || !isreal(s) || floor(s) != ceil(s) || s <= 0)
	error("Given bad circuit size");
      endif

    otherwise
      error("Problem with optional arguments");
  endswitch  



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

%!test
%! assert(isa(buildCircuit({{"H",0}},2^-4,"QASM"),"QASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},2^-4,"QIASM"),"QIASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},2^-4,2,"QASM"),"QASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},2^-4,2,"QIASM"),"QIASMcircuit"));
%! fail('buildCircuit({{"H",0}},2^(-4),"QIASM",4)');
%! fail('buildCircuit({{"H",0}},2^(-4),"Q")');
%! fail('buildCircuit({{"H",0}},2^(-4),"badarg")');
%! fail('buildCircuit({{"H",0}},2^(-4),4,"badarg")');


