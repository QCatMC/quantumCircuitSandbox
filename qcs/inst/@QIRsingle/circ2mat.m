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

## -*- texinfo -*-
## @deftypefn {Function File} {@var{u} =} circ2mat (@var{g},@var{n})
##
## Compute the matrix representation for the single qubit gate @var{g}
## in @var{n} qubit space
##
## @seealso{@@QASMcircuit/circ2mat}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function U = circ2mat(g,n)
  ## N.B. this can generalize to n qubit, parallel application of
  ## single qubit operators. For this reason the @single operator
  ## is not used.  On the other hand, one could make use of
  ## repeated calls to @single/circ2mat and mat-mult the results
  ## together

  op = get(g,"name");
  tars = get(g,"tars");
  p = get(g,"params");

  ## get 2x2 unitary for op
  opU = getOpU(op,p);

  prev = n; # most recently reference qubit
  U = [1]; # Unitary for [prev,n-1] space
  for k = tars #tars should be high to low order!
    ## kron in the preceeding I space
    U = kron(U,speye(2^(prev-k-1)));
    prev = k;
    ## kron in the op
    U = kron(U,opU);
  endfor

  ## kron in remaining 'low' space
  U = kron(U,speye(2^(prev)));

endfunction

## computes the 2x2 unitary using name and parameters
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
%! assert(isequal(Iop,circ2mat(@QIRsingle("I",0),1)));
%! assert(isequal(H,circ2mat(@QIRsingle("H",0),1)));
%! assert(isequal(Z,circ2mat(@QIRsingle("Z",0),1)));
%! assert(isequal(X,circ2mat(@QIRsingle("X",0),1)));
%! assert(isequal(Y,circ2mat(@QIRsingle("Y",0),1)));
%! assert(isequal(T,circ2mat(@QIRsingle("T",0),1)));
%! assert(isequal(S,circ2mat(@QIRsingle("S",0),1)));
%! assert(isequal(circ2mat(@QIRsingle("PhAmp",0, ...
%!                                 [pi/3,pi/3,pi/3,pi/3]),1), ...
%!                U2phaseamp([pi/3,pi/3,pi/3,pi/3])));
%! assert(isequal(circ2mat(@QIRsingle("ZYZ",0, ...
%!                                 [pi/3,pi/3,pi/3,pi/3]),1), ...
%!                U2zyz([pi/3,pi/3,pi/3,pi/3])));
%! assert(isequal(circ2mat(@QIRsingle("Rn",0, ...
%!                                 [pi/3,sqrt(1/3),sqrt(1/3),sqrt(1/3),pi/3]),1), ...
%!                U2Rn([pi/3,sqrt(1/3),sqrt(1/3),sqrt(1/3),pi/3])));
%! assert(isequal(circ2mat(@QIRsingle("PhAmp",0, ...
%!                                 [pi/3,pi/3,pi/3]),1), ...
%!                U2phaseamp([pi/3,pi/3,pi/3])));
%! assert(isequal(circ2mat(@QIRsingle("ZYZ",0, ...
%!                                 [pi/3,pi/3,pi/3]),1), ...
%!                U2zyz([pi/3,pi/3,pi/3])));
%! assert(isequal(circ2mat(@QIRsingle("Rn",0, ...
%!                                 [pi/3,sqrt(1/3),sqrt(1/3),sqrt(1/3)]),1), ...
%!                U2Rn([pi/3,sqrt(1/3),sqrt(1/3),sqrt(1/3)])));

%!test
%! assert(isequal(circ2mat(@QIRsingle("H",[1,0],[]),2),tensor(H,H)))
%! assert(isequal(circ2mat(@QIRsingle("H",[2,1],[]),3),tensor(H,H,Iop)))
%! assert(isequal(circ2mat(@QIRsingle("H",[3,1],[]),5),tensor(Iop,H,Iop,H,Iop)))
%! assert(isequal(circ2mat(@QIRsingle("H",[5,2],[]),8),tensor(Iop(2),H,Iop(2),H,Iop(2))))
