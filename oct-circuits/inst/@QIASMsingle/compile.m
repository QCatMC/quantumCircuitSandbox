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
    eta0 = 0.14
    capprox = 2.6; # 4*sqrt(2);
    ## cgc = 1/sqrt(2);  
    
    ## get the SU(2) variant of the operator
    [SU,ph] = QIASMop(this.name,this.params)
    ## get U_0 and eta_0
    [seq,mat] = findclosest(SU);
        
    ## sanity check that initial approx is at least an eta0 approx
    dist = norm(SU-mat)
    assert(dist <= eta0);

    if( dist <= eta0) # good enough. why work more!
      qstrseq = seq;
    else # need to do better. more work!
      	 
      ## initial depth of SK algo
      skdep = uint32(ceil(log( (log(1/(eta*capprox^2))) / ...
			       (log(1/(eta0*capprox^2))) ) / ...
			  log(3/2)));
      ##printf("SK Depth: %d\n",skdep);
      
    
      ## compile with Solovay-Kiteav
      [qstrseq,SUapprox] = skalgo(SU,skdep);
      ## test for eta precision requirement
      assert(norm(SU-SUapprox) < eta);
      ## simplify/reduce approx. seq if possible.
      qstrseq = simpseq(qstrseq);
    endif
      
    ## convert strings to QASMsingle with correct target
    ## pack into a QASMseq. reverse for circuit order vs. Maths order
    q = @QASMseq(cellfun(@(name) @QASMsingle(name,this.tar),...
			 fliplr(qstrseq), ...
			 "UniformOutput",false));

    
  endif

endfunction



function [SU,ph] = QIASMop(name,params)

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
      endif
  endswitch

endfunction

function b = QASMsingleOp(OpStr)
	 
  switch (OpStr)
    case {"I","X","Z","Y","H","T","S","I'",...
	  "X'","Z'","Y'","H'","T'","S'" }
      b = true; 
    otherwise
      b = false; 
  endswitch

endfunction
