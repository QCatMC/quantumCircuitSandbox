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

## Usage: n = numapprox(this)
##
## Returns the number of non-elementary operators in this, i.e.
## the number that must be approximated.
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM

function n = numapprox(this)
  s = get(this,"seq");
  n = 0;
  for k = 1:length(s)
    n = n + numapprox(s{k});
  endfor
endfunction

%!test
%! C = @QIASMseq({@QIASMcNot(0,1),@QIASMsingle("H",3),@QIASMmeasure([])});
%! assert(0,numapprox(C));
%! d = {@QIASMsingle("PhAmp",[pi,pi,pi],0), @QIASMsingle("ZYZ",[pi,pi,pi],0)};
%! assert(2,numapprox(@QIASMseq(d)));
%! assert(2,numapprox(@QIASMseq({@QIASMsingle("X",0),@QIASMseq(d)})));
