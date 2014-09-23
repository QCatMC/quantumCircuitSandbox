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

## Usage: C = parseQASMDesc(desc)
##
## construct a quantum circuit by parsing a descriptor cell array.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits


function C = parseQASMDesc(desc)

  if( iscell(desc) )
    ## all descriptors are sequences
    C = @QASMseq(cellfun(@parseCNode,desc,"UniformOutput",false));
  else
    error("parse error: expecting cell array and got something different");
  endif

endfunction

%!test
%! assert(false);

function C = parseCNode(cndesc)
  ## seq nodes and gate nodes are both cell arrays	 
  if( iscell(cndesc) )
    ## first is string. should be a Gate
    if(ischar(cndesc{1}) )
      C = parseGate(cndesc);
    ## frist is cell. should be another seq.
    elseif( iscell(cndesc{1}) )
      C = parseDescriptor(cndesc);
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

%!test
%! assert(false);

## parses gate descriptors
function C = parseGate(gDesc)
  ## Check if gate name is one of the known, able to be simulated, set
  if( validOp(gDesc{1}) ) 
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

## true if o is the name of a single qubit operator
function b = isSingle(o)
  b = strcmp(o,"H") || strcmp(o,"X") || strcmp(o,"I") ...
      || strcmp(o,"Z") || strcmp(o,"S") || strcmp(o,"T") || ...
      strcmp(o,"Y") || strcmp(o,"H'") || strcmp(o,"X'")  || ...
      strcmp(o,"I'") || strcmp(o,"Z'") || strcmp(o,"S'") || ...
      strcmp(o,"T'") || strcmp(o,"Y'");
endfunction

%!test
%! assert(false)

## parse the descriptor of a single qubit operation
function C = parseSingle(gDesc)
  op = gDesc{1};

  if(length(gDesc) != 2)
    error("parse error: too many arguments given to %s",op);
  elseif( !isNat(gDesc{2}) )
    error("parse error: %s target must be a natural number. Given %f.", ...
	  op,gDesc{2});
  else
    C = @QASMsingle(op,gDesc{2});
  endif

endfunction

%!test
%! assert(false)

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
    C = @QASMcNot(gDesc{2},gDesc{3});
  endif

endfunction

%!test
%! assert(false);


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
      C = @QASMmeasure(gDesc{2});
    endif
  endif

endfunction

%!test
%! gates = ["I","X","Y","Z","S","T","H"];
%! for k = 1:length(gates)
%!   res = parseGate({gates(k),2});
%!   assert(isa(res,"singleGate"));
%! endfor 
%!
%! assert(isa(parseGate({"CNot",2,0}),"cNotGate"));
%! assert(isa(parseGate({"Measure"}),"measureGate"));
%! assert(isa(parseGate({"Measure",0:3}),"measureGate"));

