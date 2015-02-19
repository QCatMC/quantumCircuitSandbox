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
## @deftypefn {Function File} {@var{C} =} compile (@var{A})
##
## Compile @var{A} to an equivalent @QASMcircuit.
## Users should not use this directly, but should instead use the
## quantum circuit compiler (qcc)
##
##
## @seealso{qcc}
##
## @end deftypefn


function q = compile(this)

  q = @QIASMcircuit(compile(get(this,"seq")),get(this,"bits"));

endfunction
