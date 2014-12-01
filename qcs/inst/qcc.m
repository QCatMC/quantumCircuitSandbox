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
##   C = qcc(cir)
##     For non QASM circuits cir, this compiles cir to a QASM circuit
##     that approximates cir with precision <= 2^-7
##   C = qcc(cir,tar)
##     Compile cir to target language tar. If tar is QASM, then approximation
##     precision is <= 2^-7
##   C = qcc(cir,eta)
##     Copile cir to QASM circuit with approximation precision <= eta
##   C = qcc(cir,eta,tar)
##     Compile cir to target langauge tar with approximation precision <= eta
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function C = qcc(desc,varargin )

  ## validate desc. SHould be a cell array descriptor, or an object
  ## of type @QIRcircuit, @QIASMcircuit, or @QASMcircuit
  if( !iscell(desc) && !isa(desc,"QIRcircuit") && ...
      !isa(desc,"QIASMcircuit") && !isa(desc,"QASMcircuit") )
    error("Given bad circuit");
  endif

  ## parse optional arguments. get precision eta and target language tar
  [eta,tar] = parseargs(varargin);

  ##At this point all inputs (desc, eta, tar) are valid and initialized
  ##  desc is either a cell array (descriptor),  a QIR circuit, a QIASM
  ##  circuit, or a QASM circuit
  ##  eta is from (0,1)
  ##  tar is either QIR, QASM, or QIASM

  ## check bad combos.. i.e. decompile requests
  if( isa(desc,"QASMcircuit") && ...
      ( strcmp(tar,"QIASM")  || strcmp(tar,"QIR") ))
    error("Cannot decopile QASM");
  elseif( isa(desc,"QIASMcircuit") && strcmp(tar,"QIR") )
    error("Cannot decopile QIASM");
  endif

  ## must be a workable input/target combo

  ## check for do nothing request
  if( isa(desc,"QASMcircuit") || ...
      ( isa(desc,"QIASMcircuit") && strcmp(tar,"QIASM") ) ||
      ( isa(desc,"QIRcircuit") && strcmp(tar,"QIR") ) )

    C = desc;

  else ## desc is either cell-desc,QIR, or QIASM

    ## Descriptors at least get converted to QIR
    if( iscell(desc) )
      ## build QIASM circuit with size derived from targets
      C = @QIRcircuit(parse(desc));
    else # QIR || QIASM
      C = desc;
    endif
    ## post: C is QIR | QIASM

    ## bump to QIASM if needed
    if( isa(C,"QIRcircuit") && !strcmp(tar,"QIR") )
      C = compile(C);
    endif

    ## if target is QASM then compile one last time
    if( strcmp(tar,"QASM") )
      ## compile to QASM
      C = compile(C,eta);
    endif

  endif

endfunction

## true if obj lhs is of target type rhs
function b = tareq(lhs,rhs)
  b = (isa(lhs,"QIRcircuit") && strcmp(rhs,"QIR")) || ...
      (isa(lhs,"QIASMcircuit") && strcmp(rhs,"QIASM")) || ...
      (isa(lhs,"QASMcircuit") && strcmp(rhs,"QASM"));
endfunction

## args is the cell array possibly containing the target and precision for
## the compiler. Parseargs processes this array and produces the appropriate
##  precision eta and target language t
function [eta,t] = parseargs(args)

  nargs = length( args );

  switch(nargs)
    case 0 ## defaults
      eta = 2^(-7);
      t = "QIR";

    case 1 ## either or
      arg = args{1};

      ## should be target
      if(ischar(arg) && ...
        ( strcmp("QIR",arg) || strcmp("QIASM",arg) || strcmp("QASM",arg) ) )
        eta = 2^(-7);
        t = arg;
        ## should be eta
      elseif(!ischar(arg) && isscalar(arg) ...
        && isreal(arg) && arg > 0 && arg < 1)
        eta = arg;
        t = "QIR";
      else
        error("Bad third argument. Expecting circuit approximation error or build target string");
      endif

    case 2 ## size,target

      t = args{2};
      ## check target string
      if( !ischar(t) || ...
	  ( !strcmp("QIR",t) && !strcmp("QIASM",t) && !strcmp("QASM",t)) )
	error("Given bad build target string");
      endif

      eta = args{1};
      ## validate approximation threshold eta
      if( ischar(eta) || !isreal(eta) || !isscalar(eta) || ...
	  eta <= 0 || eta >= 1)
	error("Given bad approximation error threshold eta");
      endif

    otherwise
      error("Problem with optional arguments");
  endswitch
endfunction

## accuracy and correctness of parse and compile functions are tested
##  in those functions.

%!test
%! fail('qcc(5)');
%! fail('qcc({{"H",0}},5)');
%! fail('qcc({{"H",0}},0)');
%! fail('qcc({{"H",0}},-2)');
%! fail('qcc({{"H",0}},1)');
%! fail('qcc({{"H",0}},"Q")');
%! fail('qcc({{"H",0}},2^(-4),"Q")');
%! fail('qcc({{"H",0}},2^(-4),"badarg")');
%! fail('qcc(@QASMcircuit(),"QIASM")');

%!test
%! assert(isa(qcc({{"H",0}}),"QASMcircuit"));
%! assert(isa(qcc({{"H",0}},2^-4),"QASMcircuit"));
%! assert(isa(qcc({{"H",0}},2^-4,"QASM"),"QASMcircuit"));
%! assert(isa(qcc({{"H",0}},"QASM"),"QASMcircuit"));
%! assert(isa(qcc({{"H",0}},"QIASM"),"QIASMcircuit"));
%! assert(isa(qcc({{"H",0}},2^-4,"QIASM"),"QIASMcircuit"));
%! c = qcc({{"H",0}},"QIASM");
%! d = qcc(c);
%! assert(eq(qcc(c,"QASM"),d));
%! assert(eq(qcc(c),d));
%! assert(eq(c,qcc(c,"QIASM")));
%! assert(eq(d,qcc(d)));
