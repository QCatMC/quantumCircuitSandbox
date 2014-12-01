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
##  used to compute the n qubit operator corresponding to the
##  measurement operator g. CURRENTLY DOES NOT FUNCTION.

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function U = circ2mat(g,n)
  ## not a unitary operator, but we can compute the projector.
  ## using this leaves the system in an un-normalized state!
  tars = get(g,"tar");

  U = zeros(2^n);
  s = (0:(2^n-1))';
  for t = tars
    v = s == t;
    U(:,t+1) = v;
  endfor

endfunction

%!test
%! m = @measure([1]);
%! assert(isequal(circ2mat(m,1),[0,0;0,1]));
%! m = @measure([0]);
%! assert(isequal(circ2mat(m,1),[1,0;0,0]));
%! m = @measure([0,1]);
%! assert(isequal(circ2mat(m,1),eye(2)));
%! m = @measure([1,3,5]);
%! D = diag(0:2^4-1);
%! r = (D==1)+(D==3)+(D==5);
%! assert(isequal(circ2mat(m,4),r));
