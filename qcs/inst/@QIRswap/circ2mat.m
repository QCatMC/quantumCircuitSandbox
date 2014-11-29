
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
  tar1 = get(g,"tar1");
  tar2 = get(g,"tar2");

  ##  Unitary to swap two adjacent qubits
  swapadj = sparse([1,0,0,0; 0,0,1,0; 0,1,0,0; 0,0,0,1]);

  if( abs(tar1-tar2) == 1) # adjacent
    U = tensor(speye(2^(n-max(tar1,tar2)-1)), ...
               swapadj, speye(2^(min(tar1,tar2))));
  else # not adjacent
    ## is there an efficient way to do this without compiling?
    U = circ2mat(compile(g),n);
  endif

endfunction

## test adjacent swaps.
%!test
%! swapadj = sparse([1,0,0,0; 0,0,1,0; 0,1,0,0; 0,0,0,1]);
%! assert(isequal(swapadj,circ2mat(@QIRswap(0,1),2)));
%! assert(isequal(swapadj,circ2mat(@QIRswap(1,0),2)));
%! assert(isequal(tensor(Iop,swapadj),circ2mat(@QIRswap(0,1),3)));
%! assert(isequal(tensor(swapadj,Iop),circ2mat(@QIRswap(2,1),3)));

## non-adjacent swaps... should test more
%!test
%! r = eye(8)(:,[1,5,3,7,2,6,4,8]);
%! assert(isequal(r,circ2mat(@QIRswap(2,0),3)));
%! assert(isequal(r,circ2mat(@QIRswap(0,2),3)));
