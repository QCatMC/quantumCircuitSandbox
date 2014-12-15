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

## compute Solovay-Kitaev parameters w.r.t sample of SU2 operators and
##  table of initial approximationss

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function capprox = computeskparams(fname,tname)

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


  addpath("../qcs/inst:../qcs/inst/@QIASMsingle/private");

  ## filename for results. 2*n = samples per pi
  [fd,fnam] = fileparts(fname);
  [td,tnam] = fileparts(tname);

  logname = sprintf("./data/skparams-%s-%s.mat",fnam,tnam);

  ##d(I,V),d(I,W) for each operators Group Commutators
  gcdists = zeros(length(params),2);
  cgcs = zeros(length(params),2);
  eta0s = zeros(length(params),1);
  eta1s = zeros(length(params),1);
  capproxs = zeros(length(params),1);


  for j = 1:length(su2s)
    ## current SU(2) op
    u = su2s{j};

    ## get U0 approx
    [seq,u0] = skalgo(u,0);
    eta0s(j) = norm(u-u0); #eta on zero approx

    ## if U0 approx is not more or less the same as u.. i.e. it's not
    ## in the table
    if( eta0s(j) > 2^-30 )
      [V,W] = getGroupComm(u*(u0')); # get Group Commutators

      ## get distances from I for each commutator
      gcdists(j,1) = norm(V-eye(2));
      gcdists(j,2) = norm(W-eye(2));

      ## compute upper-bound on cgc from d(I,X) < cgc*sqrt(eta0)
      ## these are values specific to the operator j
      cgcs(j,:) = gcdists(j,:)/sqrt(eta0s(j));

      [seq,u1] = skalgo(u,1);
      eta1s(j) = norm(u-u1);
      capproxs(j) = (eta1s(j))/(eta0s(j)^(3/2));

    endif

  endfor

  ## table global values
  eta0 = max(eta0s);
  eta1 = max(eta1s);
  cgc = max(max(gcdists))/sqrt(eta0);
  capprox = eta1/(eta0^(3/2));


  ## for each U in SU(2)
  save("-append",logname,"gcdists"); #d(V,I),d(W,I) for [V,W]
  save("-append",logname,"eta0s"); # d(U,U0)
  save("-append",logname,"eta1s"); # d(U,U1)
  save("-append",logname,"cgcs"); # U not in Table, d(W,I)/sqrt(d(U,U0))
  save("-append",logname,"capproxs"); #

  ## estimate from table
  save("-append",logname,"cgc");  #cgc infimum
  save("-append",logname,"capprox"); ##capprox infimum
  save("-append",logname,"eta0");
  save("-append",logname,"eta1");

  ## clean up
  clear -g all;
  rmpath("../qcs/inst:../qcs/inst/@QIASMsingle/private");

endfunction
