
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
##  used to compute the n qubit unitary corresponding to the
##  controlled-not operator g

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function U = circ2mat(g,n)
  ## get target and control
  tar = get(g,"tar");
  ctrl = get(g,"ctrl");

  ## get the op
  oparr = get(g,"op");
  op = oparr{1};
  if( length(oparr) == 1 )
    p = [];
  else
    p = oparr{2};
  endif

  opU = getOpU(op,p);

  lowbits = min(tar,ctrl);
  highbits = (n-1) - max(tar,ctrl);
  midbits = max(tar,ctrl) - min(tar,ctrl)-1;

  low = speye(2^lowbits);
  high = speye(2^highbits);
  mid = speye(2^midbits);

  P0 = sparse([1,0;0,0]);
  P1 = sparse([0,0;0,1]);

  if( tar < ctrl )
    U = tensor(high,P0,mid,speye(2),low) + ...
	tensor(high,P1,mid,opU,low);
  else
    U = tensor(high,speye(2),mid,P0,low) + ...
	tensor(high,opU,mid,P1,low);
  endif

endfunction


function opU = getOpU(op,p)
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
endfunction


%!test
%! assert(false);
