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
## @deftypefn {Function File} {@var{B} =} binaryrep (@var{k},@var{n})
##
## Compute the binary representation, as a row vector, of a  positive integer.
##
## The @var{n}-bit binary representation of positive integer @var{k} is returned as a row vector. When @var{k} is a vector of integers, then the binary represtation of all the integers is returned as a @code{length(k)} by @var{n} matrix where row @math{i} is the binary reprentation of @code{k(i)}.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Misc

function b = binaryrep(k,n)
  b = zeros(length(k),n);

  for j=1:length(k)
    b(j,:) = uint8(bitget(k(j),n:-1:1));
  endfor
end

%!test
%!  expect = [0,0,0; 0,0,1; 0,1,0; 0,1,1; ...
%!            1,0,0; 1,0,1; 1,1,0; 1,1,1];
%!  assert(expect, binaryrep([0:7],3));
