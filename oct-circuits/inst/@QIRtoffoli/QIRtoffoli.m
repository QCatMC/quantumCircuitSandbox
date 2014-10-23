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

## Usage: g = @QIRtoffoli(tar,ctrls)
##
## Construct a gate object for a Toffoli gate controlled from ctrls
## targetting tar

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function g = QIRtoffoli(tar,ctrls)

  if( nargin == 0 )
    ## default to bad gate
    g.tar = 0;
    g.ctrls = zeros(1,2);
  else
    g.tar = tar;
    g.ctrls = ctrls;
  endif
  g = class(g,"QIRtoffoli");

endfunction
