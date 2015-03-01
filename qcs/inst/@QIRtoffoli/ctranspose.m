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
## @deftypefn {Function File} {@var{h} =} ctranspose (@var{g})
##
## Computes the reverse of the Toffoli gate @var{g}. Enables @var{g}'.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function s = ctranspose(g)
  s = @QIRtoffoli(get(g,"tar"),get(g,"ctrls"));
endfunction

%!test
%! err = 2^-40;
%! a = @QIRtoffoli(0,[1,2]);
%! n = 3;
%! assert( operr( circ2mat(a,n)', circ2mat(a',n) ) < err );
%! a = @QIRtoffoli(5,[2,4]);
%! n = 6;
%! assert( operr( circ2mat(a,n)', circ2mat(a',n) ) < err );
%! a = @QIRtoffoli(4,[1,6]);
%! n = 8;
%! assert( operr( circ2mat(a,n)', circ2mat(a',n) ) < err );
