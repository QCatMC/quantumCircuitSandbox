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
## @deftypefn {Function File} {@var{C} =} QIRswap (@var{t},@var{s})
##
## Construct swap gate that swaps qubits @var{t} and @var{s}
## Users should not construct gates directly but instead use
## some combination of QIR, horzcat, and qcc
##
## @seealso{QIR,qcc, @@QIRcircuit/horzcat }
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function g = QIRswap(tar1,tar2)

  if( nargin == 0 )
    ## default to Identity on qubit 0
    g.tar1 = 0;
    g.tar2 = 0;
  else
    g.tar1 = tar1;
    g.tar2 = tar2;
  endif
  g = class(g,"QIRswap",@QIRgate());

endfunction
