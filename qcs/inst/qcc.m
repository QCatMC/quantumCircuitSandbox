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

## -*- texinfo -*-
## @deftypefn {Function File} {@var{C} =} qcc (@var{cir})
## @deftypefnx {Function File} {@var{C} =} qcc (@var{cir},@var{opt},@var{opt-val},...)
##
## Quantum Circuit Compiler. Compile a high-level circuit to an equivalent or approxmiate lower-level circuit.
##
## The quantum circuit compiler (qcc) is used to produce a lower level circuit @var{C} from a higher level circuit @var{cir}. For QIR to QIASM compilation, the two circuits are equivalent. For QIASM to QASM compilation, the QASM circuit will be an approximation that results from the application of the Soloay-Kitaev algorithm. Optional arguments can be used to control the target language and approximation accuracy.
##
## By default, @code{qcc(@var{C})} will compile to a circuit one level down the QIR > QIASM > QASM hierarchy and use an approximation accuracy of 2^-7.  The following options allow the user to control the target and accuracy.
##
## ``target''
##
## @quotation
##  The ``target'' option can be either ``QIR'', ``QIASM'', or ``QASM''.  It should be a circuit langauge of equal or lower level than @var{cir}.
## @end quotation
##
## ``accuracy''
##
## @quotation
## The accuracy value should be a positive, real-valued number from (0,1). When the target langauge is not QASM, this option has no effect. Currently, the Solovay-Kitave compilation process can take considerable time. Users are encouraged to install and load the parallel packge from Octave forge as qcc will take advantage of this to speed up the compilation process. Requesting circuit accuracy better than the default 2^-7 is likely to result in lengthy compilations.
## @end quotation
##
## The circuit argument can also be so-called circuit descriptor.  This is simply a cell array representing a qcs circuit.  Building circuits from descriptors is not recommended and support for this may be dropped in future versions. Users are encouraged to use @code{QIR} and @code{horzcat}, or @code{[a,b]}, to construct their circuits. QIR circuits can then be compiled to lower level representations as needed.
##
## @seealso{QIR}
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function C = qcc(desc,varargin )

  ## validate desc. SHould be a cell array descriptor, or an object
  ## of type @QIRcircuit, @QIASMcircuit, or @QASMcircuit
  if( !iscell(desc) && !isa(desc,"QIRcircuit") && ...
      !isa(desc,"QIASMcircuit") && !isa(desc,"QASMcircuit") )
    error("Given bad circuit");
  endif

  inType = typeinfo(desc);
  if( strcmp("class",inType) )
    inType = class(desc);
  endif

  ## get optional arguments
  ## parse optional arguments. get precision eta and target language tar
  #[eta,tar] = parseargs(varargin,inType);
  [r,tar,eta] = parseparams(varargin,"target",oneMore(inType),...
                                     "accuracy",2^-7);


  ## error check optional argument values
  if( !isempty(r) )
    error("qcc: problem with optional arguments.")
  endif

  if( !strcmp("QIR",tar) && !strcmp("QIASM",tar) && !strcmp("QASM",tar))
    error("qcc: bad target language given. %s",tar);
  endif

  if( !isscalar(eta) && !isreal(eta) && (eta < 0 || eta > 1) )
    error("qcc: bad accuracy given. %f",eta);
  endif

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

function t = oneMore(inType)
  switch(inType)
    case "cell"
     t = "QIR";
    case "QIRcircuit"
     t = "QIASM";
    case {"QIASMcircuit","QASMcircuit"}
     t = "QASM";
    otherwise
     error("qcc: bad circuit type.")
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
%! fail('qcc({{"H",0}},"Q",2^(-4))');
%! fail('qcc({{"H",0}},"badarg",2^(-4))');
%! fail('qcc(@QASMcircuit(),"QIASM")');

%!test
%! assert(isa(qcc({{"H",0}}),"QIRcircuit"));
%! assert(isa(qcc({{"H",0}},"accuracy",2^-4),"QIRcircuit"));
%! assert(isa(qcc({{"H",0}},"target","QASM","accuracy",2^-4),"QASMcircuit"));
%! assert(isa(qcc({{"H",0}},"target","QASM"),"QASMcircuit"));
%! assert(isa(qcc({{"H",0}},"target","QIASM"),"QIASMcircuit"));
%! assert(isa(qcc({{"H",0}},"target","QIASM","accuracy",2^(-4)),"QIASMcircuit"));
%! c = qcc({{"H",0}},"target","QIASM");
%! d = qcc(c);
%! assert(eq(qcc(c,"target","QASM"),d));
%! assert(eq(qcc(c),d));
%! assert(eq(c,qcc(c,"target","QIASM")));
%! assert(eq(d,qcc(d)));
