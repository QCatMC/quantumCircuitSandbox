
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
  tar1 = max(get(g,"tars"));
  tar2 = min(get(g,"tars"));
  ctrl = get(g,"ctrl");

  P0c = tensor(speye(2^(n-ctrl-1)),sparse([1,0;0,0]),speye(2^ctrl));
  P1c = tensor(speye(2^(n-ctrl-1)),sparse([0,0;0,1]),speye(2^ctrl));
  
  U = P0c*speye(2^n) + P1c*circ2mat(@QIRswap(tar1,tar2),n);
	 
endfunction


%!test
%! assert(false);
