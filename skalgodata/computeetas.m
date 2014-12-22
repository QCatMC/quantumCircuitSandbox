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

## compute Solovay-Kitaev etas for a sample of SU2 operators and
##  table of initial approximations, for all recursion depths 0:d

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function etas = computeetas(fname,tname,d)

  ## quick param check
  if( !ischar(tname) )
    error("tname should be a string");
  elseif( !ischar(fname) )
    error("fname should be string");
  endif

  ## load file and check for UZERO
  load(fname);
  if( !exist("UZERO") )
    error("no UZERO loaded from %s",fname);
  endif

  load(tname);
  if( !exist("su2s") )
    error("no su2s loaded from %s",tname);
  endif

  if( floor(d) != ceil(d) || d < 0 )
    error("bad recursion depth %f",d);
  endif

  addpath("../qcs/inst:../qcs/inst/@QIASMsingle/private");

  ## filename for results. 2*n = samples per pi
  [fd,fnam] = fileparts(fname);
  [td,tnam] = fileparts(tname);

  logname = sprintf("./data/etas0to%d-%s-%s.mat",d,fnam,tnam);

  ## eta table
  etas = zeros(length(su2s),d+1);

  for k = 0:d
    for j = 1:length(su2s)
      ## current SU(2) op
      u = su2s{j};

      if( k == 0 )
        ## get U0 approx
        [seq,ud] = skalgo(u,0);
        etas(j,1) = norm(u-ud); #eta on zero approx
      else
        if( etas(1) > 2^-30 )
          [seq,ud] = skalgo(u,k);
          etas(j,k+1) = norm(u-ud); #eta on zero approx
        else
          etas(j,k+1) = etas(k);
        endif
      endif
    endfor #end for each operator
    ## for each U in SU(2)
    save(logname,"etas");
  endfor # end for each depth


  ## clean up
  clear UZERO su2s;
  rmpath("../qcs/inst:../qcs/inst/@QIASMsingle/private");

endfunction
