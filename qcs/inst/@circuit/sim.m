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
## @deftypefn {Function File} {} sim {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuit


## simulate t steps, with respect to nesting depth d, of the Circuit
## cir on input in. Input in must be a valid pure state
## representation of a standard basis state for the qubit space of cir.
function s = sim(cir,in,d,t)

  if( d > cir.maxDepth )
    error("simulate: given depth exceeds circuit max depth.");
  elseif( t > cir.stepsAt(d) )
    error("simulate: given number of simulation steps exceepds max \
for given depth.");
  endif

  s = sim(cir.seq,in,cir.bits,1,d,0,t);

endfunction

%! c = @circuit(@seq({@single("H",0)}),1,1,[1],[0]);
%!error(sim(c,[0;1],3,1));
%!error(sim(c,[0;1],1,2));
