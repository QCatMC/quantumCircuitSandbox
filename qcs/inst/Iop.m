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
## @deftypefn {Function File} {@var{U} =} Iop (@var{n})
##
## Compute the Identity Matrix.
##
## Given no inputs @code{Iop} returns the single qubit Identity matrix. For any @math{@var{n}>1} it returns the @var{N} qubit Identity matrix.
##
## @seealso{H,X,Y,Z,S,T,Rx,Ry,Rz,Rn,Ph}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = Iop(n=1)

  ## error check number of qubits
  if( n < 0 )
    error("Number of qubits must be 0 or greater. Given n=%d",n);
  endif

  U = eye(2^n);

endfunction


%!test
%! I1 = eye(2);
%! assert(Iop,I1);
%! assert(kron(I1,I1),Iop(2));
%! assert(kron(I1,kron(I1,I1)),Iop(3));
