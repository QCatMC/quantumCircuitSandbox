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

## run and profile skalgo run on n random phase/amp
## SU2s, with recursion depth d, and  w.r.t UZERO found in fname

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function pData = profskalgo(fname,n,d)

  ## load file and check for UZERO
  load(fname);
  if( !exist("UZERO") )
    error("no UZERO loaded from %s",fname);
  endif

  addpath("../qcs/inst:../qcs/inst/@QIASMsingle/private");

  profile clear;
  profile off;
  for j = 1:n
    ## current SU(2) op U
    p = randparams = [unifrnd(0,pi/2,1,1),unifrnd(0,2*pi,1,2)];
    U = U2phaseamp(p);

    profile resume;
    [s,m] = skalgo(U,d);
    profile off;

  endfor


  ## clean up
  clear -g UZERO;
  rmpath("../qcs/inst:../qcs/inst/@QIASMsingle/private");
  pData = profile("info");

endfunction
