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

## Usage: C = horzcat(this,other)
##
## returns @QIRcircuit C = [a,b]
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function C = horzcat(this,varargin)
  seq = {this};

  for g = varargin
    other = g{1};
    switch(class(other))
      case {"QIRsingle","QIRswap","QIRtoffoli","QIRfredkin","QIRcU", ...
      "QIRmeasure" }
         seq{end+1} = other;
      case "QIRcircuit"
          s = get(get(other,"seq"),"seq");
          ## combine sequences 
          if( length(s) > 0 )
             seq = {seq{:},s{:}};
          endif
      otherwise
         error("Invalid gate type %s encountered",class(other));
    endswitch
  endfor
  seq
  C = @QIRcircuit(@QIRseq(seq));
endfunction

%!test
%! assert(false);