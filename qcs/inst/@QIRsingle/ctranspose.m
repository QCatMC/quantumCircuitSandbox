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

## Usage: g = ctranspose(g)
##
## invert a gate via g'
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function s = ctranspose(g)

   temp = ctranspose(@single(get(g,"name"),0,get(g,"params")));
   s = @QIRsingle(get(temp,"name"),get(g,"tars"),get(temp,"params"));

endfunction

%!test
%! err = 2^-40;
%! a = @QIRsingle("T",0);
%! n = 1;
%! assert( operr( circ2mat(a,n)',circ2mat(a',n) ) < err );
%! a = @QIRsingle("T",[0,3]);
%! n = 4;
%! assert( operr( circ2mat(a,n)',circ2mat(a',n) ) < err );
%! a = @QIRsingle("T",[1,3,5]);
%! n = 8;
%! assert( operr( circ2mat(a,n)',circ2mat(a',n) ) < err );
