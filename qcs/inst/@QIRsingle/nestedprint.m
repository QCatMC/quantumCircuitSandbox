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
## @deftypefn {Function File} {} nestedprint (@var{g},@var{d})
##
## Display the single qubit gate @var{g} with indentation depth @var{d}
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function nestedprint(sGate,dep,clip=16)
  pad = blanks(dep*3);
  fprintf("%s{",pad);
  op=sGate.name;
  if( strcmp(op,"PhAmp") || strcmp(op,"Rn") || strcmp(op,"ZYZ") )
    fprintf("\"%s(",op);
    fprintf("%.3f,",sGate.params(1:(length(sGate.params)-1)));
    fprintf("%.3f)\"",sGate.params( end ));
  else
    fprintf ("\"%s\"",op);
  endif
  ## print targets
  fprintf(",[");
  fprintf("%d,",sGate.tars(1:(length(sGate.tars)-1)));
  fprintf("%d]}\n",sGate.tars(end));
endfunction
