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

## compute n randomly generated phase/amp operators from SU2

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: operators


function eta0 = randPhaseAmp(n)

  if( !isscalar(n) || n < 1 || floor(n) != ceil(n) || !isreal(n))
    error("number of samples should be positive integer");
  endif

  addpath("../qcs/inst");

  logname = sprintf("./data/randPhaseAmp-%dsamps-%s.mat",n,datestr(now,30));

  params = zeros(n,3);
  su2s = cell(1,n);

  for j = 1:rows(params)
    ## random phase/amp parameters
    randparams = [unifrnd(0,pi/2,1,1),unifrnd(0,2*pi,1,2)];

    params(j,:) = randparams;

    ## current SU(2) op
    su2s{j} = U2phaseamp(randparams);

  endfor


  save(logname,"params");
  ## for each U in SU(2)
  save("-append",logname,"su2s");

  ## clean up
  clear -g all;
  rmpath("../qcs/inst");


endfunction
