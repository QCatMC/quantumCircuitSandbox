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

## Usage: s = set(cir, varargin)
##
## circuit field mutator. 


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QASM

function s = set(cir,varargin)
  s = cir;
  if (length (varargin) < 2 || rem (length (varargin), 2) != 0)
    error ("set: expecting property/value pairs");
  endif

  while (length (varargin) > 1)
    prop = varargin{1};
    val = varargin{2};
    varargin(1:2) = [];
    if (ischar (prop) )
       switch(prop)
	 case "bits"
	   ## its a Nat
	   if(isscalar(val) && floor(val) == ceil(val) && val > 0 )
	     s.bits = val;
	   else
	     error("Number of bits must be a natural number.");
	   endif
	 otherwise
	   error("Property not currently mutable");
       endswitch
    else
      error("Expecting property to be a string. Given something else.");
    endif

  endwhile


endfunction
