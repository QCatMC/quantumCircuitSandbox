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
## Keywords: QIR

function U = circ2mat(g,n)
  P0 = sparse([1,0;0,0]);
  P1 = sparse([0,0;0,1]);
  X = sparse([0,1;1,0]);
  ctrl1 = max(get(g,"ctrls"));
  ctrl2 = min(get(g,"ctrls"));
  tar = get(g,"tar");

  high = n-max(ctrl1,tar)-1; ##bits above
  low = min(ctrl2,tar); ## bits below
  ## these are determined case by case
  midhigh = 0;
  midlow = 0;

  ## c1,c2,t
  if( ctrl2 > tar )
    midhigh = ctrl1 - ctrl2 -1;
    midlow = ctrl2 - tar - 1;

    U = speye(2^n) - ...
	tensor(speye(2^high),P1,speye(2^midhigh),P1,...
	       speye(2^(midlow+low+1))) + ...
	tensor(speye(2^high),P1,speye(2^midhigh),P1,...
	       speye(2^midlow),X,speye(2^low));


  ## c1,t,c2
  elseif( ctrl1 > tar )
    midhigh = ctrl1 - tar - 1;
    midlow = tar - ctrl2 - 1;

    U = speye(2^n) - ...
	tensor(speye(2^high),P1,speye(2^(midhigh+1+midlow)),...
	       P1,speye(2^low)) + ...
	tensor(speye(2^high),P1,speye(2^midhigh),X,speye(2^midlow),...
	       P1,speye(2^low));

  ## t,c1,c2
  else
    midhigh = tar - ctrl1 - 1;
    midlow = ctrl1 - ctrl2 - 1;

    U = speye(2^n) - ...
	tensor(speye(2^(high+1+midhigh)),...
	   P1,speye(2^midlow),P1,speye(2^low)) + ...
	tensor(speye(2^high),X,speye(2^midhigh),...
	       P1,speye(2^midlow),P1,speye(2^low));

  endif

endfunction


%!test
%! r = eye(8)(:,[1,2,3,4,5,6,8,7]);
%! assert(isequal(r,circ2mat(@QIRtoffoli(0,[2,1]),3)));
%! assert(isequal(r,circ2mat(@QIRtoffoli(0,[1,2]),3)));
%! r = eye(8)(:,[1,2,3,4,5,8,7,6]);
%! assert(isequal(r,circ2mat(@QIRtoffoli(1,[2,0]),3)));
%! assert(isequal(r,circ2mat(@QIRtoffoli(1,[0,2]),3)));
%! r = eye(8)(:,[1,2,3,8,5,6,7,4]);
%! assert(isequal(r,circ2mat(@QIRtoffoli(2,[1,0]),3)));
%! assert(isequal(r,circ2mat(@QIRtoffoli(2,[0,1]),3)));
%! r = eye(8)(:,[1,2,3,4,5,6,8,7]);
%! assert(isequal(tensor(Iop(2),r), ...
%!                circ2mat(@QIRtoffoli(0,[1,2]),5)));
%! assert(isequal(tensor(r,Iop(2)), ...
%!                circ2mat(@QIRtoffoli(2,[4,3]),5)));
