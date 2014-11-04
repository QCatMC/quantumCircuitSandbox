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
## Keywords: QIASM

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
%! assert(false);
