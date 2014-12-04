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
## Keywords: circuits

function U = circ2mat(g)
  U = circ2mat(g.seq,g.bits);
endfunction

%!test
%! c = @circuit(@seq({@single("H",0,[]),@single("H",1,[])}), ...
%!              2,1,[2],[0,1]);
%! assert(isequal(kron(H,H),circ2mat(c)));
