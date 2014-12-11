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

## Usage: g = ctranspose(g)
##
## invert a gate via g'
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function s = ctranspose(g)

  switch (g.name)
    case {"I","X","Y","Z","H"}
      s = @single(g.name,g.tar,[]);
    case {"S","T"}
      s = @single(strcat(g.name,"'"),g.tar,[]);
    case {"S'","T'"}
      s = @single(g.name(1),g.tar,[]);
    case "PhAmp"
      U = circ2mat(g,1);
      p = phaseAmpParams(U');
      s = @single(g.name,g.tar,p);
    case "Rn"
      U = circ2mat(g,1);
      p = RnParams(U');
      s = @single(g.name,g.tar,p);
    case "ZYZ"
      U = circ2mat(g,1);
      p = zyzParams(U');
      s = @single(g.name,g.tar,p);
  endswitch

endfunction

%!test
%! assert(false);
