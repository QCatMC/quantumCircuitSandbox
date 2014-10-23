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
##   C = buildCircuit(cir,tar)
##   C = buildCircuit(cir,eta)
##   C = buildCircuit(cir,eta,tar)
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function C = buildCircuit(desc,varargin )

  ## validate desc
  if( !iscell(desc) && !isa(desc,"QIASMcircuit") && !isa(desc,"QASMcircuit") )
    error("Given bad circuit");
  endif

  ## parse optional arguments
  [eta,tar] = parseargs(varargin);

  ##At this point all inputs are valid and initialized
  ##  desc is either a cell array (descriptor),  a QIASM
  ##  circuit, or a QASM circuit
  ##  eta is from (0,1)
  ##  tar is either QASM or QIASM			

  ## check bad combos
  if( isa(desc,"QASMcircuit") && strcmp(tar,"QIASM") )
    error("Cannot decopile QASM to QIASM");
  endif

  ## workable combo
  if( isa(desc,"QASMcircuit") ) ## does nothing

    C = desc;

  else # desc or QIASM with tar either QIASM or QASM

    ## Descriptors at least get converted to QIASM
    if( iscell(desc) )
      ## build QIASM circuit with size derived from targets
      C = @QIASMcircuit(parse(desc));     
    else #QIASM
      C = desc;
    endif

    ## C is now a QIASM  
    ## if target is QASM then compile
    if( strcmp(tar,"QASM") )  
      ## compile to QASM
      C = compile(C,eta);
    endif
    
  endif
  
endfunction

function [eta,t] = parseargs(args)

  nargs = length( args );

  switch(nargs)
    case 0 ## defaults
      eta = 2^(-7);
      t = "QASM";
    case 1 ## either or
      arg = args{1};

      ## should be target
      if(ischar(arg) && ( strcmp("QIASM",arg) || strcmp("QASM",arg) ) )
	eta = 2^(-7);
	t = arg;	
      ## should be eta
      elseif(!ischar(arg) && isscalar(arg) && isreal(arg) && arg > 0 && arg < 1)
	eta = arg;
	t = "QASM";
      else
	error("Bad third argument. Expecting circuit approximation error or build target string");
      endif
    case 2 ## size,target

      t = args{2};
      if( !ischar(t) || (!strcmp("QIASM",t) && !strcmp("QASM",t)) )
	error("Given bad build target string");
      endif

      eta = args{1};
      ## validate approximation threshold eta
      if( !isreal(eta) || !isscalar(eta) || eta <= 0 || eta >= 1) 
	error("Given bad approximation error threshold eta");
      endif

    otherwise
      error("Problem with optional arguments");
  endswitch  
endfunction

## accuracy and correctness of parse and compile functions are tested
##  in those functions. 

%!test
%! fail('buildCircuit(5)');
%! fail('buildCircuit({{"H",0}},5)');
%! fail('buildCircuit({{"H",0}},0)');
%! fail('buildCircuit({{"H",0}},-2)');
%! fail('buildCircuit({{"H",0}},1)');
%! fail('buildCircuit({{"H",0}},"Q")');
%! fail('buildCircuit({{"H",0}},2^(-4),"Q")');
%! fail('buildCircuit({{"H",0}},2^(-4),"badarg")');
%! fail('buildCircuit(@QASMcircuit(),"QIASM")');

%!test
%! assert(isa(buildCircuit({{"H",0}}),"QASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},2^-4),"QASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},2^-4,"QASM"),"QASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},"QASM"),"QASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},"QIASM"),"QIASMcircuit"));
%! assert(isa(buildCircuit({{"H",0}},2^-4,"QIASM"),"QIASMcircuit"));
%! c = buildCircuit({{"H",0}},"QIASM");
%! d = buildCircuit(c);
%! assert(eq(buildCircuit(c,"QASM"),d));
%! assert(eq(buildCircuit(c),d));
%! assert(eq(c,buildCircuit(c,"QIASM")));
%! assert(eq(d,buildCircuit(d)));





