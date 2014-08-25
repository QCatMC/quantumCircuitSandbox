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

## usage: t = stepsAt(cir,d)
##
## Returns the number of steps at depth d for the circuit object cir

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function t = stepsAt(cir,d)

  if( !isa(cir,"circuit") )
    error("Given something other than a circuit as first argument.");
  elseif( !isNat(d) || d == 0 )
    error("Depth must be positive, non-zero integer.");
  endif

  if( d > get(cir,"maxDepth") )
    t = 0;
  else
    t = get(cir,"stepsAt")(d);
  endif

endfunction


%!test
%! assert(false)
