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
## @deftypefn {Function File} {@var{U} =} H (@var{n})
##
## Compute the Hadamard Matrix.
##
## Given no inputs @code{H} returns the single qubit Hadamard matrix. For any @math{@var{n}>1} it returns the @var{N}th tensor power of @code{H}.
##
## @seealso{Iop,X,Y,Z,S,T,Rx,Ry,Rz,Rn,Ph}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = H(n=1)

  U = nbitop(sqrt(1/2)*[1,1;1,-1],n);

endfunction


%!test
%! H1 = sqrt(1/2)*[1,1;1,-1];
%! assert(H,H1);
%! assert(kron(H1,H1),H(2));
%! assert(kron(H1,kron(H1,H1)),H(3));
