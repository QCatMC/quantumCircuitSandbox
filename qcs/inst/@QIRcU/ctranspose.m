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

   op = get(g,"op");
   if( length(op) == 1)
     p = [];
   else
     p = op{2};
   endif

   temp = ctranspose(@single(op{1},0,p));

   if( length(op) == 1)
     s = @QIRcU(get(g,"tar"),get(g,"ctrl"),{get(temp,"name")});
   else
     s = @QIRcU(get(g,"tar"),get(g,"ctrl"),{get(temp,"name"), ...
                get(temp,"params")});
   endif

endfunction

%!test
%! err = 2^-40;
%! a = @QIRcU(0,1,{"Z"});
%! n = 2;
%! assert( operr(circ2mat(a,n)',circ2mat(a',n)) < err);
%! a = @QIRcU(2,0,{"Z"});
%! n = 3;
%! assert( operr(circ2mat(a,n)',circ2mat(a',n)) < err);
%! a = @QIRcU(1,0,{"T"});
%! n = 2;
%! assert( operr(circ2mat(a,n)',circ2mat(a',n)) < err);
%! a = @QIRcU(1,2,{"PhAmp",pi/3*ones(1,4)});
%! n = 4;
%! assert( operr(circ2mat(a,n)',circ2mat(a',n)) < err);
