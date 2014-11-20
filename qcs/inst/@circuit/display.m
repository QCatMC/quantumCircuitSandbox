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

## Usage: display(cir)
##
## Display function for circuit objects. 
##
## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuit

function display(cir)

  if(!strcmp(inputname(1),"") )
    fprintf ("%s = \n", inputname (1)); 
  endif

  pad = blanks(3);
  fprintf("%sseq = \n",pad);
  nestedPrint(cir.seq,2);
  fprintf("%snum bits = %d\n",pad,cir.bits);
  fprintf("%stargets = [",pad);
  fprintf("%d,",cir.tars(1:length(cir.tars)-1));
  fprintf("%d]\n",cir.tars(length(cir.tars)));
  fprintf("%smax depth = %d\n",pad,cir.maxDepth);

  for d = 1:cir.maxDepth

    s=cir.stepsAt(d);
    if( s == 1)
      sstr = "step";
    else
      sstr = "steps";
    endif

    fprintf("%s%d %s at Depth %d\n",blanks(3),s,sstr,d)

  endfor

  
endfunction

