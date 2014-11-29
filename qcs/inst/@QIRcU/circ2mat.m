
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
##  controlled-U operator g

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function U = circ2mat(g,n)
  ## get target and control
  tar = get(g,"tar");
  ctrl = get(g,"ctrl");

  ## get the op and parameters
  oparr = get(g,"op");
  op = oparr{1};
  if( length(oparr) == 1 )
    p = [];
  else
    p = oparr{2};
  endif

  ## compute the unitary.. hacky code reuse to get 2x2 unitary 
  opU = circ2mat(@single(op,0,p),1);

  ## compute size of non-ctrl/tar spaces then compute Identity for them
  lowbits = min(tar,ctrl);
  highbits = (n-1) - max(tar,ctrl);
  midbits = max(tar,ctrl) - min(tar,ctrl)-1;

  low = speye(2^lowbits);
  high = speye(2^highbits);
  mid = speye(2^midbits);

  ## sparse projectors
  P0 = sparse([1,0;0,0]);
  P1 = sparse([0,0;0,1]);

  ## no compute the unitary
  if( tar < ctrl )
    U = tensor(high,P0,mid,speye(2),low) + ...
      	tensor(high,P1,mid,opU,low);
  else
    U = tensor(high,speye(2),mid,P0,low) + ...
	      tensor(high,opU,mid,P1,low);
  endif

endfunction

%!test
%! p0 = [1,0;0,0]; p1 = [0,0;0,1];
%! assert(isequal(circ2mat(@QIRcU(0,1,{"X"}),2), kron(p0,Iop)+kron(p1,X)));
%! assert(isequal(circ2mat(@QIRcU(1,0,{"X"}),2), kron(Iop,p0)+kron(X,p1)));
%! assert(isequal(circ2mat(@QIRcU(0,2,{"X"}),4), tensor(Iop,p0,Iop,Iop)+...
%!                                               tensor(Iop,p1,Iop,X)))
%! assert(isequal(circ2mat(@QIRcU(3,1,{"X"}),6), tensor(Iop(4),p0,Iop)+...
%!                                               tensor(Iop(2),X,Iop,p1,Iop)))
