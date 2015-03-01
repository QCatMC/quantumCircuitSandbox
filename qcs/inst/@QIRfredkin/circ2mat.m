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
## Compute the matrix representation for the Fredkin gate @var{g}
## in @var{n} qubit space
##
## @seealso{@@QIRcircuit/circ2mat}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function U = circ2mat(g,n)
  tar1 = max(get(g,"tars"));
  tar2 = min(get(g,"tars"));
  ctrl = get(g,"ctrl");

  ## projectors
  P0c = tensor(speye(2^(n-ctrl-1)),sparse([1,0;0,0]),speye(2^ctrl));
  P1c = tensor(speye(2^(n-ctrl-1)),sparse([0,0;0,1]),speye(2^ctrl));

  ## project and add two subspace operations
  U = P0c*speye(2^n) + P1c*circ2mat(@QIRswap(tar1,tar2),n);

endfunction


%!test
%! r = eye(8)(:,[1,2,3,4,5,7,6,8]);
%! assert(isequal(r,circ2mat(@QIRfredkin([1,0],2),3)));
%! assert(isequal(r,circ2mat(@QIRfredkin([0,1],2),3)));
%! r = eye(8)(:,[1,2,3,7,5,6,4,8]);
%! assert(isequal(r,circ2mat(@QIRfredkin([0,2],1),3)));
%! assert(isequal(r,circ2mat(@QIRfredkin([2,0],1),3)));
%! r = eye(8)(:,[1,2,3,6,5,4,7,8]);
%! assert(isequal(r,circ2mat(@QIRfredkin([1,2],0),3)));
%! assert(isequal(r,circ2mat(@QIRfredkin([2,1],0),3)));
