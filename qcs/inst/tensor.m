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

## Usage: Q = tensor(A, ...)
## 
##  Compute the tensor of all the arguments

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Misc

function Q = tensor(varargin)
  if(nargin == 0 )
    Q = [1];
  elseif(nargin == 1)
    Q = varargin{1};
  else
    Q = varargin{1};
    for k = 2:length(varargin)
      Q = kron(Q,varargin{k})
    endfor
  endif
endfunction

%!test
%! assert(false);
