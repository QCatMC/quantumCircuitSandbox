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
    eta0 = 0.14;
    capprox = 2.6; 
    
    ## get the SU(2) variant of this
    [SU,ph] = QIASMop(this.name,this.params);
    ## get eta_0 approximation
    [seq,mat] = findclosest(SU);
        
    ## distance from SU to eta_0 approximation mat
    dist = norm(SU-mat);    
    if( dist <= eta ) # good enough. why work more!
      qstrseq = seq;
    else # need a better approximation. more work!
      	 
      ## initial depth of SK algo
      skdep = uint32(ceil(log( (log(1/(eta*capprox^2))) / ...
			       (log(1/(eta0*capprox^2))) ) / ...
			  log(3/2)));

      
  
      ## compile with Solovay-Kiteav
      [qstrseq,SUapprox] = skalgo(SU,skdep);

      ## test for eta precision requirement
      ##  *** Remove when not testing or keep for runtime errors
      assert(norm(SU-SUapprox) < eta, ...
	     "QIASM compile: unable to approximate a gate");

      ## simplify/reduce approximating sequence if possible.
      qstrseq = simpseq(qstrseq);
    endif
      
    ## convert strings to QASMsingle with correct target
    ## pack into a QASMseq. reverse for circuit order vs. Maths order
    qseq = cell(length(qstrseq));
    len = length(qseq);
    for k = 1:len
	qseq{k} = @QASMsingle(qstrseq{len+1-k},this.tar);
    endfor

    ## package approximating sequence as @QASMseq
    q = @QASMseq(qseq);
    
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


## no sk-algo needed
%!test
%! assert(eq(compile(@QIASMsingle("H",0),1/32),@QASMsingle("H",0)));
%! assert(eq(compile(@QIASMsingle("X",0),1/32),@QASMsingle("X",0)));
%! assert(eq(compile(@QIASMsingle("Y",1),1/32),@QASMsingle("Y",1)));
%! assert(eq(compile(@QIASMsingle("Z",2),1/32),@QASMsingle("Z",2)));
%! assert(eq(compile(@QIASMsingle("S",0),1/32),@QASMsingle("S",0)));
%! assert(eq(compile(@QIASMsingle("S'",0),1/32),@QASMsingle("S'",0)));
%! assert(eq(compile(@QIASMsingle("T",0),1/32),@QASMsingle("T",0)));
%! assert(eq(compile(@QIASMsingle("T'",0),1/32),@QASMsingle("T'",0)));

## testing SK-based compilation
##  I don't like this, but for this works by running a large number
##  of instances of compile, and utilizing the assert used to 
##  verify that the final approximation is within eta.

## Phase Amp 
%!test
%! params = zeros(10^4,4);
%! for k = 1:length(params)
%!   compile(@QIASMsingle("PhAmp",0,params(k,:)));
%! endfor

## Rotation about n
%!test
%! params = zeros(10^4,4);
%! for k = 1:length(params)
%!   compile(@QIASMsingle("Rn",0,params(k,:)));
%! endfor

## Z-Y-Z Rotation
%!test
%! params = zeros(10^4,4);
%! for k = 1:length(params)
%!   compile(@QIASMsingle("ZYZ",0,params(k,:)));
%! endfor
