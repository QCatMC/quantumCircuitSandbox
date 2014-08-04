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

## Usage: C = parseDescriptor(desc)
##
## construct a quantum circuit by parsing a descriptor cell array.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits


function C = parseDescriptor(desc)

  if( iscell(desc) )

    if( ischar(desc{1}) ) 
      C = parseGate(desc);
    elseif( iscell(desc{1}) )
      C = @seqNode(cellfun(@parseDescriptor,desc,"UniformOutput",false));
    endif

  else
    error("parse error: expecting Cell array and got something different");
  endif

endfunction

## parses gate descriptors
function C = parseGate(gDesc)

  if( validOp(gDesc{1}) ) 
    op = gDesc{1}; 
    if( isSingle(op) ) 
      C = parseSingle(gDesc);
    elseif( strcmp(op,"CNot") )
      C = parseCNot(gDesc);
    elseif( strcmp(op,"Measure") )
      C = parseMeasure(gDesc);
    else
      error("parse error: Something went really wrong");
    endif
  else
    error("parse error: Trying to parse Operator but given bad operator name: %s.",gDesc{1});
  endif

endfunction


function b = isSingle(o)
  b = strcmp(o,"H") || strcmp(o,"X") || strcmp(o,"I") ...
      || strcmp(o,"Z") || strcmp(o,"S") || strcmp(o,"T") || strcmp(o,"Y");
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


function C = parseSingle(gDesc)
  op = gDesc{1};

  if(length(gDesc) != 2)
    error("parse error: too many arguments given to %s",op);
  elseif( !isNat(gDesc{2}) )
    error("parse error: %s target must be a natural number. Given %f.", ...
	  op,gDesc{2});
  else
    C = @singleGate(op,gDesc{2});
  endif

endfunction


function C = parseCNot(gDesc)

  if( length(gDesc) != 3 )
    error("parse error: CNot expects 2 arguments. Given %d",length(gDesc)-1);
  elseif( !isNat(gDesc{2}) || !isNat(gDesc{3}) )
    error("parse error: CNot target and control must be natural \
numbers. Given tar=%f and ctrl=%f.",gDesc{2},gDesc{3});
  elseif( gDesc{2} == gDesc{3} )
    error("parse error: CNot target and control cannot be the same.");
  else
    C = @cNotGate(gDesc{2},gDesc{3});
  endif

endfunction

function C = parseMeasure(gDesc)
	 
  if( length(gDesc) > 2 )
    error("parse error: Measure gate takes zero or 1 argument. \
Given something else.")
  elseif( length(gDesc) == 1 )
    C = @measureGate();	
  elseif( !isvector(gDesc{2}) )
    error("parse error: Measurement target must be a vector or \
scalar.");
  elseif( isvector(gDesc{2}) )
    if( sum(arrayfun(@isNat,gDesc{2})) != length(gDesc{2})  )
      error("parse error: Measurement targets must be natrual \
numbers");
    elseif( length(unique(gDesc{2})) != length(gDesc{2}) )
      error("parse error: Measurement targets must be unique.");
    endif
  else
    C = @measureGate(gDesc{2});
  endif

endfunction
