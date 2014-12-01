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

## usage: eta = operr(U,V)
##
## Compute the error, or distance, between V and U where V and U are
## both n qubit operators. a.k.a d(U,V) or E(U,V). This is the
## operator norm of the difference, || U-V ||.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function eta = operr(U,V)

  if( !isequal(size(U),size(V)) )
    error("Operators must be the same size.");
  endif

  ## 2-norm of the difference
  eta = norm(U-V);

endfunction


## just checking error checks. the reset is built-in code (norm,-)
%!test
%! fail('operr(eye(2),eye(3))')
%! fail('operr(H(3),X)')
