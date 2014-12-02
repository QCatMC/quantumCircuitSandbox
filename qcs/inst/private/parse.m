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

## Usage: C = parseQIASMDesc(desc)
##
## construct a quantum circuit by parsing a descriptor cell array.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits


function C = parse(desc)

  if( iscell(desc) )
    ## all descriptors are sequences
    s = cell(1,length(desc));
    for k = 1:length(s)
      s{k} = parseCNode(desc{k});
    endfor
    C = @QIRseq(s);
  else
    error("parse error: expecting cell array and got something different");
  endif

endfunction

function C = parseCNode(cndesc)

  ## seq nodes and gate nodes are both cell arrays
  if( iscell(cndesc) )
    ## first is string. should be a Gate
    if(ischar(cndesc{1}) )
      C = parseGate(cndesc);
    ## frist is cell. should be another seq.
    elseif( iscell(cndesc{1}) )
      C = parse(cndesc);
    ## first is neither a cell nor string... that's no good.
    else
      error("parse error: expecting gate or seqence descriptor, got \
somethign else");
    endif
  ## This should never happen, but just in case...
  else
    error("parse error: expecting cell array and got something different");
  endif

endfunction

## parses gate descriptors
function C = parseGate(gDesc)
  ## Check if gate name is one of the known, able to be simulated, set
  if( QIRvalidOp(gDesc{1}) )
    op = gDesc{1};
    ## single qubit op?
    if( isSingle(op) )
      C = parseSingle(gDesc);
    ## Binary Op?
    elseif( strcmp(op,"CNot") || strcmp(op,"CU") || strcmp(op,"Swap") )
      C = parseBinary(gDesc);
    ## Ternary Op?
    elseif( strcmp(op,"Toffoli") || strcmp(op,"Fredkin") )
      C = parseTernary(gDesc);
    ## Measurement?
    elseif( strcmp(op,"Measure") )
      C = parseMeasure(gDesc);
    else
      error("parse error: Something went really wrong");
    endif
  else
    error("parse error: Trying to parse Operator but given bad operator name: %s.",gDesc{1});
  endif

endfunction

## true if o is the name of a single qubit operator from the QIASM set
function b = isSingle(o)
  b = strcmp(o,"H") || strcmp(o,"X") || strcmp(o,"I") ...
      || strcmp(o,"Z") || strcmp(o,"S") || strcmp(o,"T") || ...
      strcmp(o,"Y") || strcmp(o,"H'") || strcmp(o,"X'")  || ...
      strcmp(o,"I'") || strcmp(o,"Z'") || strcmp(o,"S'") || ...
      strcmp(o,"T'") || strcmp(o,"Y'") || strcmp(o,"PhAmp") || ...
      strcmp(o,"ZYZ") || strcmp(o,"Rn");
endfunction

## parse the descriptor of a single qubit operation
function C = parseSingle(gDesc)
  op = gDesc{1};

  if(length(gDesc) < 2 || length(gDesc) > 3 )
    error("parse error: too many/few arguments given to %s",op);
  endif

  if(length(gDesc) == 2 )
    ## verify that it's a QASM operator
    if( strcmp(op,"PhAmp") || strcmp(op,"Rn") || strcmp(op,"ZYZ") )
      error("parse error: expecting 2 arguments for %s given 1",op);
    ## verify targets
    elseif( !isvector(gDesc{2}) ||  !isTargetVector(gDesc{2}) )
      error("parse error: %s targets must be a set of natural numbers.");
    else
      C = @QIRsingle(op,sort(gDesc{2},"descend"));
    endif

  else ## it's length 3
    ## verify name
    if( !strcmp(op,"PhAmp") && !strcmp(op,"Rn") && !strcmp(op,"ZYZ") )
      error("parse error: expecting 1 arguments for %s given 2",op);
    ## verify targets
    elseif(  !isvector(gDesc{3}) || !isTargetVector(gDesc{3}) )
      error("parse error: %s target must be a set of natural number.");
    else
      ## Error check params gDesc{2}
      switch(op)
	case {"PhAmp","ZYZ"}
	  if(!isreal(gDesc{2}) || (!isequal(size(gDesc{2}),[1,3]) &&
				   ...
				   !isequal(size(gDesc{2}),[1,4])))
	    error("parse error: parameter mismatch for %s",op);
	  endif
	case "Rn"
	  if(!isreal(gDesc{2}) || (!isequal(size(gDesc{2}),[1,4]) &&
				   ...
				   !isequal(size(gDesc{2}),[1,5])))
	    error("parse error: parameter mismatch for %s",op);
	  endif
      endswitch

      C = @QIRsingle(op,sort(gDesc{3},"descend"),gDesc{2});
    endif
  endif

endfunction

## parse the descriptor of a Binary  operation
function C = parseBinary(gDesc)
  name = gDesc{1};

  switch(name)
    case "CNot"
      ## check descriptor length
      if( length(gDesc) != 3 )
	error("parse error: CNot expects 2 arguments. Given %d",length(gDesc)-1);
      ## check target and control
      elseif( !isscalar(gDesc{2}) || !isscalar(gDesc{3}) || ...
	      !isNat(gDesc{2}) || !isNat(gDesc{3}) )
	error("parse error: CNot target and control must be natural \
numbers. Given tar=%f and ctrl=%f.",gDesc{2},gDesc{3});
      ## check target neq control
      elseif( gDesc{2} == gDesc{3} )
	error("parse error: CNot target and control cannot be the same.");
      else
	C = @QIRcU(gDesc{2},gDesc{3},{"X"});
      endif

    case "CU"
      ## descriptor length
      if( length(gDesc) != 4 )
	error("parse error: CU expects 3 arguments. Given %d",length(gDesc)-1);
      ## target and control check
      elseif( !isscalar(gDesc{3}) || !isscalar(gDesc{4}) || ...
	      !isNat(gDesc{3}) || !isNat(gDesc{4}) )
	error("parse error: CU target and control must be natural numbers.");
      ## tar neq ctrl
      elseif( gDesc{3} == gDesc{4} )
	error("parse error: CU target and control cannot be the same.");
      ## U desc check
      elseif( !iscell(gDesc{2}) || length(gDesc{2}) < 1 || length(gDesc{2}) > 2 )
	error("parse error: CU operator descriptor is bad");
      ## U name check
      elseif( !isSingle(gDesc{2}{1}) )
	error("parse error: Controlled Operation is not a known Single qubit \
operator form. Given %s",gDesc{2}{1});
      ## QIASM or QASM?
      elseif( strcmp("PhAmp",gDesc{2}{1}) ||  strcmp("ZYZ",gDesc{2}{1}) ||  ...
	      strcmp("Rn",gDesc{2}{1} ) )
	## QIASM
	## check descriptor length
	if( length(gDesc{2}) != 2 )
	  error("parse error: Expecting parameter set for %s",gDesc{4}{1});
	endif

	## verify parameters
	params = gDesc{2}{2};

	switch(gDesc{2}{1})
	  case {"ZYZ","PhAmp"}
	    if( !isreal(params) || (!isequal(size(params),[1,3]) && !isequal(size(params),[1,4])))
	      error("parse error: bad parameters for %s",gDesc{2}{1});
	    endif
	  case {"Rn"}
	    if( !isreal(params) || (!isequal(size(params),[1,5]) && !isequal(size(params),[1,4])))
	      error("parse error: bad parameters for %s",gDesc{2}{1});
	    endif
	endswitch

	C = @QIRcU(gDesc{3},gDesc{4},gDesc{2});
      else #QASM
	C = @QIRcU(gDesc{3},gDesc{4},gDesc{2});
      endif

    case "Swap"
      ## desc length check
      if( length(gDesc) != 3 )
	error("parse error: Swap expects 3 arguments. Given %d",length(gDesc)-1);
      ## tar checks
      elseif( !isscalar(gDesc{2}) || !isscalar(gDesc{3}) || ...
	      !isNat(gDesc{2}) || !isNat(gDesc{3}) )
	error("parse error: Swap targets must be natural \
numbers. Given tar1=%f and tar2=%f.",gDesc{2},gDesc{3});
      ## don't self-swap
      elseif( gDesc{2} == gDesc{3} )
	error("parse error: Swap targets cannot be the same.");
      endif

      C = @QIRswap(gDesc{2},gDesc{3});
    otherwise
      error("parse error: Bad binary operaror specification");
  endswitch

endfunction

## parse the descriptor of a measurement operation
function C = parseMeasure(gDesc)

  ## length check
  if( length(gDesc) != 2 )
    error("parse error: Measure gate takes 1 argument. \
Given something else.")
  ## target is a vector
  elseif( !isvector(gDesc{2}) )
    error("parse error: Measurement target must be a vector or \
scalar.");
  elseif( isvector(gDesc{2}) )
    ##it's a vector

    ## Nat check
    if( !isNat(gDesc{2}) )
      error("parse error: Measurement targets must be natrual \
numbers");

    ## no-dup check
    elseif( length(unique(gDesc{2})) != length(gDesc{2}) )
      error("parse error: Measurement target vector contains duplicates");
    else
      C = @QIRmeasure(sort(gDesc{2},"descend"));
    endif
  endif

endfunction

## parse the descriptor of a ternary operation
function C = parseTernary(gDesc)
  name = gDesc{1};

  ## name check
  switch(name)
    case "Toffoli"
      ## desc length check
      if( length(gDesc) != 3 )
	error("parse error: Toffoli expects 2 arguments.");
      ## control check
      elseif( !isequal(size(gDesc{3}),[1,2]) || !isNat(gDesc{3}) || ...
	      gDesc{3}(1) == gDesc{3}(2) )
	error("parse error: Toffoli given bad controls");
      ## target check
      elseif( !isscalar(gDesc{2}) || !isNat(gDesc{2}) || ...
	      !isequal([0,0],gDesc{3}==gDesc{2}) )
	error("parse error: Toffoli given bad target");
      endif

      C = @QIRtoffoli(gDesc{2},sort(gDesc{3},"descend"));

    case "Fredkin"
      ## desc length check
      if( length(gDesc) != 3 )
	error("parse error: Fredkin expects 2 arguments.");
      ## control check
      elseif( !isequal(size(gDesc{2}),[1,2]) || !isNat(gDesc{2}) || ...
	      gDesc{2}(1) == gDesc{2}(2) )
	error("parse error: Fredkin given bad controls");
      ## target check
      elseif( !isscalar(gDesc{3}) || !isNat(gDesc{3}) || ...
	      !isequal([0,0],gDesc{2}==gDesc{3}) )
	error("parse error: Fredkin given bad control");
      endif

      C = @QIRfredkin(sort(gDesc{2},"descend"),gDesc{3});

    otherwise
      error("parse error: Bad ternary operator specification");
  endswitch

endfunction

%!test
%! assert(false);
