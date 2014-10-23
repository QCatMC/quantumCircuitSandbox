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
    C = @QIASMseq(cellfun(@parseCNode,desc,"UniformOutput",false));
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
  if( QIASMvalidOp(gDesc{1}) ) 
    op = gDesc{1}; 
    ## single qubit op?
    if( isSingle(op) ) 
      C = parseSingle(gDesc);
    ## CNot?
    elseif( strcmp(op,"CNot") )
      C = parseCNot(gDesc);
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
    if( strcmp(op,"PhAmp") || strcmp(op,"Rn") || strcmp(op,"ZYZ") )
      error("parse error: expecting 2 arguments for %s given 1",op);
    elseif( !isNat(gDesc{2}) )
      error("parse error: %s target must be a natural number. Given %f.", ...
	    op,gDesc{2});
    else
      C = @QIASMsingle(op,gDesc{2});
    endif
  else
    if( !strcmp(op,"PhAmp") && !strcmp(op,"Rn") && !strcmp(op,"ZYZ") )
      error("parse error: expecting 1 arguments for %s given 2",op);
    elseif( !isNat(gDesc{3}) )
      error("parse error: %s target must be a natural number. Given %f.", ...
	    op,gDesc{2});
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
	  if(!isReal(gDesc{2}) || (!isequal(size(gDesc{2}),[1,4]) &&
				   ...
				   !isequal(size(gDesc{2}),[1,5])))
	    error("parse error: parameter mismatch for %s",op);
	  endif
      endswitch

      C = @QIASMsingle(op,gDesc{3},gDesc{2});
    endif
  endif

endfunction

## parse the descriptor of a Controlled Not operation
function C = parseCNot(gDesc)

  if( length(gDesc) != 3 )
    error("parse error: CNot expects 2 arguments. Given %d",length(gDesc)-1);
  elseif( !isNat(gDesc{2}) || !isNat(gDesc{3}) )
    error("parse error: CNot target and control must be natural \
numbers. Given tar=%f and ctrl=%f.",gDesc{2},gDesc{3});
  elseif( gDesc{2} == gDesc{3} )
    error("parse error: CNot target and control cannot be the same.");
  else
    C = @QIASMcNot(gDesc{2},gDesc{3});
  endif

endfunction

## parse the descriptor of a measurement operation
function C = parseMeasure(gDesc)
	 
  if( length(gDesc) != 2 )
    error("parse error: Measure gate takes 1 argument. \
Given something else.")
  elseif( !isvector(gDesc{2}) )
    error("parse error: Measurement target must be a vector or \
scalar.");
  elseif( isvector(gDesc{2}) )
    if( sum(arrayfun(@isNat,gDesc{2})) != length(gDesc{2})  )
      error("parse error: Measurement targets must be natrual \
numbers");
    elseif( length(unique(gDesc{2})) != length(gDesc{2}) )
      error("parse error: Measurement targets must be unique.");
    else
      C = @QIASMmeasure(gDesc{2});
    endif
  endif

endfunction


%!test
%! assert(false);
