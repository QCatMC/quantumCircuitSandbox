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

## Usage: C = parseGate(gDesc)
##
## construct a quantum circuit by parsing a descriptor of a Gate.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits


function C = parseGate(gDesc)

  if( validOp(gDesc{1}) ) 
    op = gDesc{1}; 

    if( isSingle(op) ) 

      if(length(gDesc) != 2)
	error("Expecting a target qubit for single gate. Given something \
else");
      elseif( !isscalar(gDesc{2}) || gDesc{2} < 0 || ...
	      floor(gDesc{2}) != ceil(gDesc{2}) )
	error("Target must be a Natural Number. Given %f.",gDesc{2});
      else
	  C = @singleGate(gDesc{1},gDesc{2});
      endif

    elseif( strcmp(op,"CNot") )

      if( length(gDesc) != 3 )
	error("CNot expects 2 arguments. Given %d",length(gDesc)-1);
      elseif( gDesc{2} == gDesc{3} || gDesc{2} < 0 || gDesc{3} < 0 ...
	      || !isscalar(gDesc{2}) || !isscalar(gDesc{3}) )
	error("Bad target and control qubits. tar = %d. ctrl = %d", ...
	      gDesc{2},gDesc{3});
      else
	C = @cNotGate(gDesc{2},gDesc{3});
      endif

    elseif( strcmp(op,"Measure") )
     
      if( length(gDesc) > 2 )
	error("Exepected one one argument, a target qubit vector. \
Got something else.");
      elseif( length(gDesc) == 1 )
	C = @measureGate();	
      elseif( isTargetVector(gDesc{2}) )
	C = @measureGate(gDesc{2});
      else
	error("Bad Target vector in measure gate.");
      endif

    else
      error("Something went really wrong");
    endif
  else
    error("Trying to parse Operator but given bad operator %s.",gDesc{1});
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

