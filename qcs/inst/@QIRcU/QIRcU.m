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

## Usage: g = @QIRcU(tar,ctrl,U)
##
## Constructor for a QIR c-U gate object. Gate targets qubit number tar
## with control qubit ctrl

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function g = QIRcU(tar,ctrl,op)

  if( nargin == 0 )
    ## default to a bad gate (ctrl == tar)
    g.tar = 0;
    g.ctrl = 0;
    g.op = {"I"}
  else
    g.ctrl = ctrl;
    g.tar = tar;
    g.op = op;  # {"name"} | {"name",params}
  endif
  g = class(g,"QIRcU");
endfunction
