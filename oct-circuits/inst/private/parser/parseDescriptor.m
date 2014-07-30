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

## Usage: C = parseDescriptor(desc)
##
## construct a quantum circuit by parsing a descriptor cell array.
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Circuits


function C = parseDescriptor(desc)

  if( iscell(desc) )
    if( ischar(desc{1}) )
      C = parseGate(desc);
    else ## should be a sequence
      s={};
      for k = 1:length(desc)
	s={parseDescriptor(desc{k})}
      endfor
      C = @seqNode(s);
    endif
  else
    error("Expecting Cell array and got something different");
  endif


endfunction
