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
## @deftypefn {Function File} {} circ2mat {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function U = circ2mat(g,n)
  ## CNot parameters: target and control qubit
  tar = g.tar;
  ctrl = g.ctrl;

  ## size of space not in {ctrl,tar}
  lowbits = min(tar,ctrl);
  highbits = (n-1) - max(tar,ctrl);
  midbits = max(tar,ctrl) - min(tar,ctrl)-1;

  ## Operators for unaffected spaces
  low = speye(2^lowbits);
  high = speye(2^highbits);
  mid = speye(2^midbits);

  ##  Projectors
  P0 = sparse([1,0;0,0]);
  P1 = sparse([0,0;0,1]);
  ## sparse X
  spX = sparse([0,1;1,0]);

  ## Compute the Operator
  if( tar < ctrl )
    U = tensor(high,P0,mid,speye(2),low)+...
        tensor(high,P1,mid,spX,low);
  else
    U = tensor(high,speye(2),mid,P0,low)+...
        tensor(high,spX,mid,P1,low);
  endif
endfunction

%!test
%! P0 = [1,0;0,0]; P1 = [0,0;0,1];
%! assert(isequal(circ2mat(@cNot(0,1),2), ...
%!                kron(P0,Iop)+kron(P1,X)));
%! assert(isequal(circ2mat(@cNot(1,0),2), ...
%!                kron(Iop,P0)+kron(X,P1)));

%!test
%! P0 = [1,0;0,0]; P1 = [0,0;0,1];
%! assert(isequal(circ2mat(@cNot(1,3),5), ...
%!                tensor(eye(2),P0,eye(2^3))+...
%!                tensor(eye(2),P1,eye(2),X,eye(2))));
%! assert(isequal(circ2mat(@cNot(3,1),5), ...
%!                tensor(eye(2^3),P0,eye(2))+...
%!                tensor(eye(2),X,eye(2),P1,eye(2))));
