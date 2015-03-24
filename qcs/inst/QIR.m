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
## @deftypefn {Function File} {@var{G} =} QIR (@var{name},@var{params},...)
## @deftypefnx {Function File} {@var{G} =} QIR
## @deftypefnx {Function File} {@var{G} =} QIR()
##
## Construct a gate from the QIR family of gates or an empty QIR circuit.
##
## The @code{QIR} function is the primary method of constructing gates for circuits. When no arguments are give, then @var{G} is an empty QIR circuit. Otherwise @var{G} is a QIR gate. When constructing gates, the first argument is always the name of the gate. The remaining arguments depend on the type of gate to be constructed.
##
## ``I'',``X'',``Y'',``Z'',``S'',``T'',``H'',``I'@w{}'',``X'@w{}'',``Y'@w{}'',``Z'@w{}'',``S'@w{}'',``T'@w{}'',``H'@w{}''
##
## @quotation
## These QASM gates take a single param, @var{t} which is a vector of the indexes of the target qubits to which the gate will be applied. The target vector @var{t} should contain a proper subset of the natrual numbers. For example, @code{QIR("H",0:3)} produces the gate that applies the single qubit Hadamard gate to the four lowest order qubits.
## @end quotation
##
## ``CNot''
##
## @quotation
##   @code{QIR("CNot",@var{t},@var{c})} is the Controlled Not gate with target @var{t} and control @var{c}. The target index @var{t} and the control index @var{c} must be natural numbers and cannot be equivalent.
## @end quotation
##
## ``Toffoli''
##
## @quotation
##   @code{QIR("Toffoli",@var{t},@var{c})} is the three qubit Toffoli gate, aka Controlled-Controlled-Not, with target @var{t} and controls @var{c}.  The controls @var{c} must be a pair of non-equivalent natrual numbers. The target @var{t} must also be a natrual number and cannot be equivalent to either of the targets.
## @end quotation
##
## ``Swap''
##
## @quotation
##   @code{QIR("Swap",@var{t1},@var{t2})} is the Swap gate which swaps qubit @var{t1} and @var{t2}. The targets must be natural numbers and cannot be equivalent.
## @end quotation
##
## ``Fredkin''
##
## @quotation
##   @code{QIR("Fredkin",@var{t},@var{c})} is the three qubit Fredkin gate, or Controlled-Swap, with targets @var{t} and control @var{c}. The targets @var{t} must be a pair of unique natural numbers and the control @var{c} must be a natural number that is not equivalent to either target.
## @end quotation
##
## ``Measure''
##
## @quotation
##    @code{QIR("Measure",@var{t})} is a measurement in the standard basis on the target qubits @var{t}. The target vector @var{t} must contain a proper subset of the natural numbers.
## @end quotation
##
## ``Rn''
##
## @quotation
##  @code{QIR("Rn",@var{p},@var{t})} is an arbitrary single qubit operation, expressed as a rotation about an axis, applied to target qubits @var{t}. The target vector @var{t} must be a proper subset of the natural numbers. The parameters of the operator are given by the parameter vector @var{p} which must either be length four or five. In both cases, @code{@var{p}(1)} is the angle of rotation and @code{@var{p}(2:4)} are the @math{(x,y,z)} coordinates of the axis. If given, @code{@var{p}(5)} is the global phase shift applied to the rotation.
## @end quotation
##
## ``PhAmp''
##
## @quotation
##  @code{QIR("PhAmp",@var{p},@var{t})} is an arbitrary single qubit operation, expressed with Phase and Amplitude parameters, applied to target qubits @var{t}. The target vector @var{t} must be a proper subset of the natural numbers. The parameters of the operator are given by the parameter vector @var{p} which must either be length three or four. In both cases, @code{@var{p}(1)} is the amplitude parameter and  @code{@var{p}(2:3)} are the row and column phases. If given, @code{@var{p}(4)} is the global phase.
## @end quotation
##
## ``ZYZ''
##
## @quotation
##  @code{QIR("ZYZ",@var{p},@var{t})} is an arbitrary single qubit operation, expressed as a sequence of rotations about the Z, then Y, then Z axes, applied to target qubits @var{t}. The target vector @var{t} must be a proper subset of the natural numbers. The parameters of the operator are given by the parameter vector @var{p} which must either be length three or four. In both cases, @code{@var{p}(1)} is angle of rotation for the first Z axis rotation, @code{@var{p}(2)} is the angle of rotation for the Y axis rotation, and @code{@var{p}(3)} is the angle of rotation for the final Z axis rotation. If given, @code{@var{p}(4)} is the global phase.
## @end quotation
##
## ``CU''
##
## @quotation
##  @code{QIR("CU",@var{o},@var{t},@var{c})} is a Controlled arbitrary single qubit operator applied to target qubit @var{t} based on control qubit @var{c}.  The operator is specified by the argument @var{o}. For QASM gates, the operator specifier @var{o} can either be the name of a gate given as a string or a cell array containing only the string name. For arbitrary unitary gates, the operator specifier @var{o} is a length two cell array where @code{@var{o}@{1@}} is the name of the parameterized gate and @code{@var{o}@{2@}} is its parameter vector.
## @end quotation
##
##
##  Gates and circuits can be used to construct circuits using the @code{[]} operators in a fashion simlar to constructing vectors. For gates a,b, and c, @code{[a,b,c]} produces a depth one circuit. Circuits may also be nested within other circuits but in order to ensure proper nesting you must begin a circuit with the empty circuit. For example, @code{[a,[b,c]]},@code{[[a,b],c]}, and @code{[a,b,c]} all produce the same depth 1 circuit with no nesting but @code{[QIR,a,[b,c]]} and @code{[QIR,[a,b],c]} will produce depth 2 circuits. The former with @code{[b,c]} at depth 2 and the later with @code{[a,b]} at depth 2.
##
## @seealso{phaseampparams,Rnparams,zyzparams}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function C = QIR(name,varargin)
  if( nargin == 0 )
    C = @QIRcircuit();
    return;
  endif

  switch(name)
    case "Toffoli"
       [t,c] = parseTof(varargin);
       C = @QIRtoffoli(t,c);
    case "Fredkin"
       [t,c] = parseFred(varargin);
       C = @QIRfredkin(t,c);
    case "Swap"
       [t1,t2] = parseSwap(varargin);
       C = @QIRswap(t1,t2);
    case "Measure"
       t = parseMeasure(varargin);
       C = @QIRmeasure(t);
    case "CU"
       [o,t,c] = parseCU(varargin);
       C = @QIRcU(t,c,o);
    case "CNot"
       [t,c] = parseCNot(varargin);
       C = @QIRcU(t,c,{"X"});
    case {"PhAmp","Rn","ZYZ"}
       [t,p] = parseQIASM(name,varargin);
       C = @QIRsingle(name,sort(t,"descend"),p);
    case {"I","X","Y","Z","S","T", "H"...
          "I'","X'","Y'","Z'","S'","T'","H'"}
       t = parseQASM(name,varargin);
       C = @QIRsingle(name,sort(t,"descend"),[]);
    otherwise
       error('QIR: Unknown operator %s',name);
  endswitch

endfunction

function [t,c] = parseCNot(args)
  if( length(args) != 2)
    error("CNot: requires 2 arguments, given %d",length(args));
  endif

  t = args{1};
  c = args{2};

  if( !isscalar(t) && !isnat(t) )
    error("CNot: Bad target");
  elseif( !isscalar(c) && !isnat(c) )
    error("CNot: Bad control");
  elseif( t == c)
    error("CNot: Target and control cannot be the same");
  endif

endfunction

function t = parseQASM(name,args)
  if( length(args) != 1 )
    error("%s: Expected one argument given %d",name,length(args));
  endif

  t = args{1};

  if(!isnat(t))
    error("%s: Bad Target");
  elseif( numel(t) != numel(unique(t)) )
    error("%s: Contains duplicate targets");
  endif

endfunction

function [t,p] = parseQIASM(name,args)
  if( length(args) != 2 )
    error("%s: Expects 2 arguments, given %d",name,length(args));
  endif

  t = args{2};
  p = args{1};

  ## check params
  switch(name)
    case {"PhAmp","ZYZ"}
      if( !isreal(p) && !isequal(size(p),[1,3]) && !isequal(size(p),[1,4]) )
        error("%s: Bad parameters. Must be real and either 3 or 4 parameters");
      endif
    case "Rn"
      if( !isreal(p) && !isequal(size(p),[1,4]) && !isequal(size(p),[1,5])  )
        error("%s: Bad parameters. Must be real and either 3 or 4 parameters");
      elseif( (1 - p(2:4)*(p(2:4))') > 2^(-40) )
        error("Rn: n must be a unit vector");
      endif
  endswitch

  ## check targets
  if( !isnat(t) )
    error("%s: Bad target",name);
  elseif( numel(t) != numel(unique(t)) )
    error("%s: Contains duplicate targets");
  endif

endfunction

function [t,c] = parseTof(args)

    if( length(args) != 2 )
      error("Toffoli: requires 2 arguments, given %d",length(args));
    endif

    ##  get targets and control
    t = args{1};
    c = args{2};

    ## control check
    if( !isequal(size(c),[1,2]) || !isnat(c) || c(1) == c(2) )
      error("Toffoli: Given bad controls");
    endif

    ## target check
    if( !isscalar(t) || !isnat(t) || !isequal([0,0],t==c ) )
      error("Toffoli: Given bad target");
    endif

    ## sort controls
    c = [max(c),min(c)];

endfunction

function [t,c] = parseFred(args)

  ## desc length check
  if( length(args) != 2 )
    error("Fredkin:  Expects 2 arguments given %d.",length(args));
  endif

  t = args{1};
  c = args{2};

  ## control check
  if( !isequal(size(t),[1,2]) || !isnat(t) || t(1) == t(2) )
    error("Fredkin: given bad targets");
  endif

  ## target check
  if( !isscalar(c) || !isnat(c) || !isequal([0,0],c==t) )
    error("Fredkin: given bad control");
  endif

  ## sort targets
  t  = [max(t),min(t)];

endfunction

function [t1,t2] = parseSwap(args)
  if( length(args) != 2 )
    error("Swap: Expects 2 arguments given %d.", length(args));
  endif

  t1 = args{1};
  t2 = args{2};

 if( !isscalar(t1) || !isscalar(t2) || !isnat(t1) || !isnat(t2) )
  error("Swap: targets must be natural \
numbers. Given tar1=%f and tar2=%f.",t1,t2);
 endif

 ## don't self-swap
 if( t1 == t2 )
   error("Swap: targets cannot be the same.");
 endif

  t  = [max(t1,t2),min(t1,t2)];
  t1 = t(1);
  t2 = t(2);

endfunction

function t = parseMeasure(args)
  if( length(args) != 1)
    error("Measure: Expected one argument, given %d.", length(args));
  endif

  t  = args{1};

  ## vector check
  if( !isvector(t) )
     error("Measure: target must be a vector or scalar.");
  ## Nat check
  elseif( !isnat(t) )
     error("Measure: targets must be natrual numbers");
  ## no-dup check
elseif( numel(unique(t)) != numel(t) )
    error("Measure: target vector contains duplicates");
  endif

  t = sort(t,"descend");

endfunction

function [o,t,c] = parseCU(args)

 if( length(args) != 3 )
   error("CU: Expected three arguments given %d.",length(args));
 endif

 o = args{1}; # op spec
 t = args{2}; # target index
 c = args{3}; # ctrl index
 p = []; ## params place holder

 ## op spec check
 if( !ischar(o) && !iscell(o) )
   error("CU: Operator specifier must be string or cell array.");
 elseif( ischar(o) && !ismember(o, {"I","X","Y","Z","S","T","H" ...
                                    "I'","X'","Y'","Z'","S'","T'","H'"}))
   error("CU: Expecting QASM operator and given something else");
 elseif( iscell(o) && length(o) == 1 && ...
         !ismember(o{1},{"I","X","Y","Z","S","T","H" ...
                         "I'","X'","Y'","Z'","S'","T'","H'"}))
   error("CU: Expecting QASM operator and given something else");
 elseif( iscell(o) && length(o) == 2 && ...
         !ismember(o{1},{"PhAmp","Rn","ZYZ"}) )
   error("CU: Expecting QIASM operator and given something else");
 endif
 ## op spec is good

 ##  reuse single qubit parsers to verify target and params
 if(iscell(o) && length(o) == 1)
   parseQASM(o{1},{t});
 elseif(iscell(o) && length(o) == 2)
   parseQIASM(o{1},{o{2},t});
 else ##ischar
   parseQASM(o,{t});
 endif

 ## repack string spec in cell spec
 if( ischar(o) )
   o = {o};
 endif

 if( !isnat(c) )
  error("CU: bad control index");
 elseif( t==c )
   error("CU: Target and Control cannot match");
 endif

endfunction

%!test
%! assert(eq(@QIRtoffoli(0,[2,1]), QIR("Toffoli",0,[1,2]) ));
%! assert(eq(@QIRfredkin([1,0],2), QIR("Fredkin",0:1,2)));
%! assert(eq(@QIRswap(2,1), QIR("Swap",1,2)));
%! assert(eq(@QIRmeasure(2:-1:0), QIR("Measure",0:2)));
%! assert(eq(@QIRcU(0,1,{"X"}),QIR("CNot",0,1)));
%! assert(eq(@QIRcU(0,1,{"Z"}),QIR("CU",{"Z"},0,1)));
%! assert(eq(@QIRcU(0,1,{"Z"}),QIR("CU","Z",0,1)));
%! assert(eq(@QIRcU(0,1,{"PhAmp",pi/3*ones(1,3)}), ...
%!           QIR("CU",{"PhAmp",pi/3*ones(1,3)},0,1)));
%! assert(eq(@QIRsingle("H",2),QIR("H",2)));
%! assert(eq(@QIRsingle("T'",2),QIR("T'",2)));
%! assert(eq(@QIRsingle("PhAmp",1,[pi/3,pi/3,pi/3]), ...
%!           QIR("PhAmp",[pi/3,pi/3,pi/3],1)))
%! assert(eq(@QIRsingle("PhAmp",1,[pi/3,pi/3,pi/3,pi/4]), ...
%!           QIR("PhAmp",[pi/3,pi/3,pi/3,pi/4 ],1)))
%! assert(eq(@QIRsingle("ZYZ",1,[pi/3,pi/3,pi/3]), ...
%!           QIR("ZYZ",[pi/3,pi/3,pi/3],1)))
%! assert(eq(@QIRsingle("ZYZ",1,[pi/3,pi/3,pi/3,pi/4]), ...
%!           QIR("ZYZ",[pi/3,pi/3,pi/3,pi/4 ],1)))
%! assert(eq(@QIRsingle("Rn",1,[pi/3,sqrt(1/3),sqrt(2/3),0]), ...
%!           QIR("Rn",[pi/3,sqrt(1/3),sqrt(2/3),0],1)))

## Need to test error checking
