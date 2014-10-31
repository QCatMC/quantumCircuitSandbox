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

## compute Solovay-Kitaev constants cgc and capprox 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function capprox = computecgc(fname,n)

  if( !isscalar(n) || n < 1 || floor(n) != ceil(n) || !isreal(n))
    error("number of samples per parameter should be positive natural number");
  elseif( !ischar(fname) )
    error("fname should be string");
  endif
  
  ## load file and check for UZERO
  load(fname);
  if( !exist("UZERO") )
    error("no UZERO loaded from %s",fname);
  endif

  addpath("../oct-circuits/inst:../oct-circuits/inst/@QIASMsingle/private");
  
  ## filename for results. 2*n = samples per pi
  [d,nam] = fileparts(fname);

  logname = sprintf("./data/cgc-%sspp%d.mat",nam,2*n);

  step = pi/(2*n);
  ## paramter ranges 
  amp = (0:step:pi/2)'; #[0,pi/2]
  pha = ((0:step:2*pi)')(1:end-1); #[0,2*pi)
  ## phase/amp parameters for some SU(2) operators
  params = [kron(amp,ones(length(pha)^2,1)),...
            kron(ones(length(amp),1),kron(pha,ones(length(pha),1))),...
            kron(ones(length(amp)*length(pha),1),pha)];

  save(logname,"params");
  
  ##d(I,V),d(I,W) for each operators Group Commutators
  gcdists = zeros(length(params),2);
  eta0s = zeros(length(params),1);
  cgcs = zeros(length(params),2);

  for j = 1:rows(params)
    ## current SU(2) op
    u = U2phaseamp(params(j,:));
    
    ## get U0 approx
    [seq,u0] = skalgo(u,0)
    eta0s(j) = norm(u-u0) #eta on zero approx
    
    ## if U0 approx is not more or less the same as u.. i.e. it's not
    ## in the table
    if( eta0s(j) > 2^-30 )
      [V,W] = getGroupComm(u*(u0')); # get Group Commutators
      
      ## get distances from I for each commutator
      gcdists(j,1) = norm(V-eye(2));
      gcdists(j,2) = norm(W-eye(2));
      
      ## compute upper-bound on cg from d(I,X) < cgc*sqrt(eta0)
      
      cgcs(j,:) = gcdists(j,:)/sqrt(eta0s(j));
    endif

  endfor

  cgc = max(max(cgcs));
  capprox = 8*cgc; ## from Dawson

  save("-append",logname,"gcdists");
  save("-append",logname,"eta0s");
  save("-append",logname,"cgcs");
  save("-append",logname,"cgc");
  save("-append",logname,"capprox");

  ## clean up
  clear -g all;
  rmpath("../oct-circuits/inst:../oct-circuits/inst/@QIASMsingle/private");

endfunction
