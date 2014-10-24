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
## returns equivalent @QIASMcNot when @QIRcU is cNot, otherwise
## returns an equivalent @QIASMseq 
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR
 

function q = compile(this)

  oname = this.op{1};
  if( length(this.op) == 1 && strcmp(oname,"X"))
    q = @QASMcNot(this.tar,this.ctrl);
  else
    qseq = cell(); # the QIASM sequence    

    ## get phase and SU2 zyz params w/out computing matrix
    [zyzps,gp] = params(op);

    ## c-Ph(gp) for non SU(2) Us
    if( gp != 0 )
      qseq{end+1} = @QIASMsingle("Rn",this.ctrl,[-gp,0,0,1,0]);
      qseq{end+1} = @QIASMsingle("PhAmp",this.ctrl,[0,0,0,gp/2]);
    endif
    
    ## All cases do : A[t],Cnot(c,t),B
    qseq{end+1} = @QIASMsingle("ZYZ",this.tar,[zyzps(1),zyzps(2)/2,0,0]);
    qseq{end+1} = @QIASMcNot(this.ctrl,this.tar);
    qseq{end+1} = @QIASMsingle("ZYZ",this.tar,[0,-zyzps(2)/2,-(zyzps(3)+zyzps(2))/2,0]);

    ## all other gates but Z,Y (and some others?.... Lemma 5.5) need another cNot
    if(!strcmp("Y",oname) && !strcmp("Z",oname) )
      qseq{end+1} = @QIASMcNot(this.ctrl,this.tar);
    endif
    
    ## in general we need "C" but not if the two z rotations are the same
    if( abs(zyzps(3)-zyzps(1)) > 2^(-60) )
      qseq{end+1} = @QIASMsingle("ZYZ",this.tar,[(zyzps(3)-zyzps(1))/2,0,0,0]);
    endif

    q = @QIASMseq(qseq);

  endif

endfunction

## z is zyz params 
## g is global phase
function [z,g] = params(op)

  oname = op{1};
  z = zeros(1,3);
  switch(oname)
    case "H"
      z = [0,pi/2,pi]; ## is this a special case?
      g = pi;
    ## setup remainding QASM ops for special cases
    case "Z"
      z = [pi/2,0,pi/2];
      g = pi;
    case "Y"
      z = [0,pi,0];
      g = pi;
    case "T"
      z = [pi/8,0,pi/8];
      g = pi/4;
    case "T'"
      z = [-pi/4,0,-pi/8];
      g =-pi/4;
    case "S"
      z = [pi/4,0,pi/4];
      g = pi/2;
    case "S'"
      z = [-pi/4,0,-pi/4];
      g = -pi/2;

    case "PhAmp"
      ## convert phamp -> zyz
      z = [op{2}(3),2*op{2}(1),op{2}(2)];
      if(length(op{2}) == 4)
	g = op{2}(4);
      else
	g = 0;
      endif

    case "ZYZ"
      z = op{2}(1:3);
      if(length(op{2}) == 4)
	g = op{2}(4);
      else
	g = 0;
      endif


    case "Rn"
      ## convert Rn -> zyz

      if(length(op{2}) == 5)
	g = op{2}(5);
      else
	g = 0;
      endif

      n = op{2}(2:4);
      a = op{2}(1);
 
      if( norm([0,0,1]-n) <= 2^(-50) )#Rz/Diagonal matrix
	z = [a/2,0,a/2]; ## special case
      elseif( norm([0,1,0]-n) <= 2^(-50) ) #Ry
	z = [0,a,0]; ## special case
      elseif( norm([1,0,0]-n) <= 2^(-50) )#Rx
	z = [-pi/2,a,pi/2]; 
      elseif( abs(pi-a) < 2^(-60) && abs(n(3)) < 2^(-60)) #off-diagonal
	z = [-2*acos(n(2)),pi,0];
      else #everything else
	## compute matrix and solve from there   
	X = [0,1;1,0]; Y=[0,-i;i,0];Z=[1,0;0,-1];
	A = n(1)*X + n(2)*Y + n(3)*Z;
	U = e^(-i*a/2*A);
	z = [arg(U(2,1)*U(1,1)'),...
	     2*acos(abs(U(1,1))),...
	     arg(U(2,2)*U(2,1)')];
      endif
   
   
  endswitch


endfunction

%!test
%! assert(false);
