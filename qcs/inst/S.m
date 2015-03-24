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
## @deftypefn {Function File} {@var{U} =} S (@var{n})
##
## Compute the S phase shift matrix.
##
## Given no inputs @code{S} returns the single qubit S matrix. For any @math{@var{n}>1} it returns the @var{N}th tensor power of @code{S}.
##
## @seealso{Iop,X,Y,Z,H,T,Rx,Ry,Rz,Rn,Ph}
## @end deftypefn


## usage: U = S(n)
##
## Compute the operator that applies the single qubit S (Phase) gate to
## n sequential qubits
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = S(n=1)

  S1 = [1,0;0,i];
  U = nbitop(S1,n);

endfunction


%!test
%! S1 = [1,0;0,i];
%! assert(S,S1);
%! assert(kron(S1,S1),S(2));
%! assert(kron(S1,kron(S1,S1)),S(3));
