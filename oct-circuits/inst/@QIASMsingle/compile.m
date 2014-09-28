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

## Usage: q = compile(this)
##
## returns equivalent @QASMsinglet to @QIASMsingle when the operator
## is in QASM, otherwise the operator is approximiated by a sequence
## of QASM operators
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM
 

function q = compile(this,eta)

  if(QASMsingleOp(this.name))
    q = @QASMsingle(this.name,this.tar);

  else
    ##use SK to approximiate to within eta with a QASMseq 
      
    ## SK params -- From Dawson&Nielsen
    capprox = 4*sqrt(2);
    cgc = 1/sqrt(2);
    eta0 = 1/33; ## eta0 < capprox^(-2);
    
    ## initial depth of SK algo
    skdep = ceil(log( (log(1/(eta*capprox^2))) / ...
		      (log(1/(eta0*capprox^2))) ) / ...
		 log(3/2));
    
    ## get the SU(2) 
    [SU,ph] = getUIASMop(this.name,this.params);
    [qstrseq,SUapprox] = skalgo(SU,skdep);
    ## test for eta precision
    assert(operr(SU,SUapprox) < eta);
    ## simplify/reduce approx. seq if possible.
    qstrseq = simpseq(qstrseq);
    ## convert strings to QASMsingle with correct target
    ## pack into a QASMseq. reverse for circuit order vs. Maths order
    q = @QASMsseq(cellfun(@(name) @QASMsingle(name,this.tar),...
			   fliplr(qstrseq), ...
			   "UniformOutput",false));
  endif
endfunction


function b = QASMsingleOp(OpStr)
	 
  switch (OpStr)
    case {"I","X","Z","Y","H","T","S", ...
	  "I'","X'","Z'","Y'","H'","T'","S'" }
      b = true; 
    otherwise
      b = false; 
  endswitch

end

## SU is the SU(2) matrix. ph is the global phase
##  parameter s.t. Ph(ph)*SU = U2(name,params)
function [SU,ph] = getQIASMOp(name,params)

  switch (name)	 
    case "PhAmp"
      SU = U2phaseamp(params(1:3));
      if(length(params) == 3)
	ph = 0;
      else
	ph = params(4);
      endif
    case "Rn"
      SU = U2Rn(params(1:4));
      if(length(params) == 4)
	ph = 0;
      else
	ph = params(5);
      endif

    case "ZYZ"
      SU = U2zyz(params(1:3));
      if(length(params) == 3)
	ph = 0;
      else
	ph = params(4);
  endswitch

endfunction

