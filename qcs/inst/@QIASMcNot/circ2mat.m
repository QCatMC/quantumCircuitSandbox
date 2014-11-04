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
## Keywords: QIASM

function U = circ2mat(g,n)
  tar = g.tar;
  ctrl = g.ctrl;
  
  lowbits = min(tar,ctrl);
  highbits = (n-1) - max(tar,ctrl);
  midbits = max(tar,ctrl) - min(tar,ctrl)-1;


  low = speye(2^lowbits);
  high = speye(2^highbits);
  mid = speye(2^midbits);

  P0 = sparse([1,0;0,0]);
  P1 = sparse([0,0;0,1]);
  if( tar < ctrl )
    op = kron(P0,kron(mid,speye(2))) + ...
	 kron(P1,kron(mid,sparse([0,1;1,0])));
  else
    op = kron(speye(2),kron(mid,P0)) + ...
	 kron(sparse([0,1;1,0]),kron(mid,P1));
  endif
  
  U = kron(high,kron(op,low));

	 
endfunction

%!test
%! assert(false);
