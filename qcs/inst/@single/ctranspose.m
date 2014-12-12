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
      p = g.params;
      p(1) = 2*pi - p(1);
      p(2) = -p(2);
      p(3) = -p(3);
      if(length(p) == 4)
        p(4) = -p(4);
      endif
      s = @single(g.name,g.tar,p);
    case "Rn"
      p = g.params;
      if(length(p) == 4)
        p = [1,-1,-1,-1] .* p;
      else
        p = [1,-1,-1,-1,-1] .* p;
      endif
      s = @single(g.name,g.tar,p);
    case "ZYZ"
      p = g.params;
      t = p(1);
      p(1) = -p(3);
      p(3) = -t;
      p(2) = -p(2);
      if(length(p) == 4)
        p(4) = -p(4);
      endif
      s = @single(g.name,g.tar,p);
  endswitch

endfunction

%!test
%! err = 2^-(40);
%! g = {"X","Y","Z","H","S","T","S'","T'"};
%! for k = 1:length(g)
%!  assert(operr( circ2mat(@single(g{k},0),1)' , ...
%!                circ2mat(@single(g{k},0)',1) ) < err);
%! endfor

%!test
%! err = 2^-(40);
%! p = pi/3*(ones(1,4));
%!  assert(operr( circ2mat(@single("PhAmp",0,p),1)' , ...
%!                circ2mat(@single("PhAmp",0,p)',1) ) < err);
%! p = pi/3*(ones(1,4));
%!  assert(operr( circ2mat(@single("ZYZ",0,p),1)' , ...
%!                circ2mat(@single("ZYZ",0,p)',1) ) < err);
%! p = [pi/3,sqrt(1/3),sqrt(1/6),sqrt(1/2),pi/5];
%!  assert(operr( circ2mat(@single("Rn",0,p),1)' , ...
%!                circ2mat(@single("Rn",0,p)',1) ) < err);
