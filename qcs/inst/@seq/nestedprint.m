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
## @deftypefn {Function File} {} nestedprint {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function nestedprint(snode,dep,clip=16)

  if( !isnat(clip) )
    error("nestedprint: clip value must be a natural number");
  endif

  pad = blanks(dep*3);
  fprintf ("%s{\n",pad);
  len = length(snode.seq);
  if( len <= clip || clip == 0 )
    for k = [1:length(snode.seq)];
      nestedprint(get(snode,"seq"){k},dep+1,clip);
    endfor
  else
    ## print first clip/2
    for k = [1:ceil(clip/2)];
      nestedprint(get(snode,"seq"){k},dep+1,clip);
    endfor
    ## clip
    fprintf("\n%s...\n\n",pad);
    ## print last clip/2
    for k = [len-floor(clip/2)+1:len];
      nestedprint(get(snode,"seq"){k},dep+1,clip);
    endfor
  endif
  fprintf ("%s}\n",pad);

endfunction
