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

## Estimate eta0 for the UZERO table found in fname using n random samples 
## from SU(2). The sample parameters used, eta0 values, and the table upper
## bound on eta0 are all saved to a mat file for analysis. 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function eta0 = montecarloetazero(fname,n)

  if( !isscalar(n) || n < 1 || floor(n) != ceil(n) || !isreal(n))
    error("number of samples should be positive integer");
  elseif( !ischar(fname) )
    error("fname should be string");
  endif
  
  load(fname);

  if( !exist("UZERO") )
    error("no UZERO loaded from %s",fname);
  endif

  addpath("../oct-circuits/inst");

  ## filename for results
  [d,nam] = fileparts(fname);

  logname = sprintf("./data/eta0-%samps%d.mat",nam,n);


  params = zeros(n,3);

  
  etas = zeros(rows(params),1); # eta0 for each op

  for j = 1:rows(params)
    ## random phase/amp parameters
    randparams = [unifrnd(0,pi/2,1,1),unifrnd(0,2*pi,1,2)];    

    params(j,:) = randparams;

    ## current SU(2) op
    u = U2phaseamp(randparams);

    # map d(u,x) for each x in UZERO
    uetas = zeros(length(UZERO),1);
    for k = 1:length(UZERO)
      uetas(k) = norm(u-UZERO{k,2});
    endfor
   
    # eta0 for u is the max of uetas
    etas(j) = min(uetas); 
  endfor  

  save(logname,"params");

  save("-append",logname,"etas");

  # eta0 for UZERO is the max of the etas
  eta0 = max(etas);

  save("-append",logname,"eta0");

  clear -g all;
  rmpath("../oct-circuits/inst");

endfunction
