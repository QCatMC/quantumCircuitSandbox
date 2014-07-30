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

## Usage: c = circuit(desc,n)
##
## construct an n qubit circuit object from a descriptor cell array
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits

function c = circuit(desc,n)

  if(nargin == 0 )
    c.bits = 0;
    c.seq = @seqNode({});
  elseif(nargin == 1)
    error("@circuit requires 0 or 2 arguments. given 1.");
  else
    c.bits = n;
    c.seq = parseDescriptor(desc);   
  endif

endfunction
