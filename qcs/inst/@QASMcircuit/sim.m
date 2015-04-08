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
## @deftypefn {Function File} {@var{s} =} sim (@var{C},@var{in},@var{d},@var{t})
##
## simulate @var{t} steps, with respect to nesting ndepth @var{d}, of the Circuit
## @var{c} on input @var{in}. Input in must be a valid pure state
## representation of a standard basis state for the qubit space of cir. Users
## should not call this function directly. Simulation should be done via the
## simulate function
##
## @seealso{simulate}
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QASM

function s = sim(circ,in,d,t)

  s = sim(circ.cir,in,d,t);

endfunction
