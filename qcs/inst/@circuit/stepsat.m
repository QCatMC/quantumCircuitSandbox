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
## @deftypefn {Function File} {} stepsat {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

## Returns the number of steps at ndepth d for the circuit object cir
function t = stepsat(cir,d)

  if( floor(d) != ceil(d) || !(d > 0) )
    error("ndepth must be positive, non-zero integer.");
  endif

  if(d >= cir.maxndepth)
    t = cir.stepsat(cir.maxndepth);
  else
    t = cir.stepsat(d);
  endif


endfunction

%!test
%! c = @circuit(@seq({@single("H",0)}),1,1,[1],[0]);
%! assert(stepsat(c,1),1);
%! assert(stepsat(c,2),1);
%!error(stepsat(c,1.2));
%!error(stepsat(c,-2));
