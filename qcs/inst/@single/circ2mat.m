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

## Usage: U = circ2mat(g,n)
##
##  used to compute the n qubit unitary corresponding to the single
##  qubit gate g.

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function U = circ2mat(g,n)
  op = g.name;
  tar = g.tar;
  p = g.params;

  lowbits = tar;
  highbits = (n-1)-tar;

  low = speye(2^lowbits);
  high = speye(2^highbits);
  
  opU = zeros(2);
  switch(op)
    case {"I","I'"}
      opU = speye(2);
    case {"X","X'"}
      opU = sparse([0,1;1,0]);
    case {"Z","Z'"}
      opU = sparse([1,0;0,-1]);
    case {"Y","Y'"}
      opU = i*sparse([0,-1;1,0]);
    case {"H","H'"}
      opU = sqrt(1/2)*[1,1;1,-1];
    case "T"
      opU = sparse([1,0;0,e^(i*pi/4)]);
    case "T'"
      opU = sparse([1,0;0,e^(-i*pi/4)]);
    case "S"
      opU = sparse([1,0;0,i]);
    case "S'"
      opU = sparse([1,0;0,-i]);
    case "PhAmp"
      ## SU(2) component
      opU = zeros(2);
      opU(1,1) = e^(i*(-p(2)-p(3))/2)*cos(p(1));
      opU(2,2) = e^(i*(p(2)+p(3))/2)*cos(p(1));
      opU(2,1) = e^(i*(p(3)-p(2))/2)*sin(p(1));
      opU(1,2) = -e^(i*(-p(3)+p(2))/2)*sin(p(1));
      
      ## global phase shift if needed
      if( length(p) == 4 && abs(p(4)) > 2^(-60) )
	opU = e^(i*p(4))*opU;
      endif

    case "ZYZ"
      Z = sparse([1,0;0,-1]);
      Y = i*sparse([0,-1;1,0]);
      
      opU = e^(-i*p(1)/2*Z)*e^(-i*p(2)/2*Y)*e^(-i*p(3)/2*Z);

      if( length(p) == 4 && abs(p(4)) > 2^(-60) )
	opU = e^(i*p(4))*opU;
      endif  
      
    case "Rn"
      X = sparse([0,1;1,0]);
      Z = sparse([1,0;0,-1]);
      Y = i*sparse([0,-1;1,0]);
      
      nop = p(2)*X + p(3)*Y + p(4)*Z;
      opU = e^(-i*p(1)/2*nop);
      
      if( length(p) == 5 && abs(p(5)) > 2^(-60) )
	opU = e^(i*p(5))*opU;
      endif

    otherwise
      error("circ2mat: bad operator");
  endswitch


  U = kron(high,kron(opU,low));
	 
endfunction

%!test
%! assert(isequal(circ2mat(@single("H",0,[]),1),H))
%! assert(isequal(circ2mat(@single("X",0,[]),1),X))
%! assert(isequal(circ2mat(@single("Y",0,[]),1),Y))
%! assert(isequal(circ2mat(@single("Z",0,[]),1),Z))
%! assert(isequal(circ2mat(@single("T",0,[]),1),T))
%! assert(isequal(circ2mat(@single("S",0,[]),1),S))
%! assert(isequal(circ2mat(@single("PhAmp",0, ...
%!                                 [pi/3,pi/3,pi/3,pi/3]),1), ...
%!                U2phaseamp([pi/3,pi/3,pi/3,pi/3])));
%! assert(isequal(circ2mat(@single("ZYZ",0, ...
%!                                 [pi/3,pi/3,pi/3,pi/3]),1), ...
%!                U2zyz([pi/3,pi/3,pi/3,pi/3])));
%! assert(isequal(circ2mat(@single("Rn",0, ...
%!                                 [pi/3,sqrt(1/3),sqrt(1/3),sqrt(1/3),pi/3]),1), ...
%!                U2Rn([pi/3,sqrt(1/3),sqrt(1/3),sqrt(1/3),pi/3])));
%! assert(isequal(circ2mat(@single("PhAmp",0, ...
%!                                 [pi/3,pi/3,pi/3]),1), ...
%!                U2phaseamp([pi/3,pi/3,pi/3])));
%! assert(isequal(circ2mat(@single("ZYZ",0, ...
%!                                 [pi/3,pi/3,pi/3]),1), ...
%!                U2zyz([pi/3,pi/3,pi/3])));
%! assert(isequal(circ2mat(@single("Rn",0, ...
%!                                 [pi/3,sqrt(1/3),sqrt(1/3),sqrt(1/3)]),1), ...
%!                U2Rn([pi/3,sqrt(1/3),sqrt(1/3),sqrt(1/3)])));
 

%!test
%! assert(isequal(circ2mat(@single("H",0,[]),2),tensor(Iop,H)))
%! assert(isequal(circ2mat(@single("X",1,[]),2),tensor(X,Iop)))
%! assert(isequal(circ2mat(@single("Y",0,[]),2),tensor(Iop,Y)))
%! assert(isequal(circ2mat(@single("Z",1,[]),2),tensor(Z,Iop)))
%! assert(isequal(circ2mat(@single("T",0,[]),2),tensor(Iop,T)))
%! assert(isequal(circ2mat(@single("S",1,[]),2),tensor(S,Iop)))
