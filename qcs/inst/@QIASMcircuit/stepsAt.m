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

## usage: t = stepsAt(cir,d)
##
## Returns the number of steps at depth d for the circuit object cir

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM

function t = stepsAt(cir,d)

  if( floor(d) != ceil(d) || !(d > 0) )
    error("Depth must be positive, non-zero integer.");
  endif
  
  if(d >= cir.maxDepth)
    t = cir.stepsAt(cir.maxDepth);
  else
    t = cir.stepsAt(d);
  endif
  

endfunction


%!test
%! ## 2 at 1, 3 at 2+
%! A = @QASMcircuit(@QASMseq({@QASMsingle("X",2), ...
%!                            @QASMseq({@QASMsingle("H",2),...
%!                                      @QASMmeasure([])}) }));
%! assert(stepsAt(A,2)==3,"depth 2 failed got %d", stepsAt(A,2));
%! assert(stepsAt(A,1)==2,"depth 1 failed");
%! assert(stepsAt(A,3)==3,"depth 3 failed");
%!error stepsAt(A,0)
%!error stepsAt(A,3.3)

