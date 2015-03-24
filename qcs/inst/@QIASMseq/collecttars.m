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
## @deftypefn {Function File} {@var{t} =} collecttars (@var{g})
##
## Compute the qubit indices for all qubits targeted by @var{g}. Results
## are returned in sorted order
##
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM

function t = collecttars(this)
  t = collecttars(this.seq);
endfunction
