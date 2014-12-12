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
## Keywords: circuits

function s = ctranspose(g)

  len = length(g.seq);
  s = cell(1,len);
  for k = 1:len
    s{k} = ctranspose(g.seq{len+1-k});
  endfor

  s = @seq(s);

endfunction

## inverting individual gates is tested within the gate classes
## here we're just do a test to check the reversal process.
%!test
%! err = 2^-40;
%! a = @seq({@single("H",0),@single("T",1),@single("Z",2)});
%! n = 3;
%! assert( operr( circ2mat(a,n)' , circ2mat(a',n) ) < err );
