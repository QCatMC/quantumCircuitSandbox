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

## generate a set of uniformly distributed phase/amp operators,
## from SU2

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: operators


function su2s = uniformPhaseAmp(n)

  ## quick param check
  if( !isscalar(n) || n < 1 || floor(n) != ceil(n) || !isreal(n))
    error("number of samples per parameter should be positive natural number");
  endif

  addpath("../qcs/inst:../qcs/inst/@QIASMsingle/private");

  ## filename for results. 2*n = samples per pi
  logname = sprintf("./data/uniformPhaseAmpSU2-%dspp.mat",2*n);

  step = pi/(2*n);
  ## paramter ranges
  amp = (0:step:pi/2)'; #[0,pi/2]
  pha = ((0:step:2*pi)')(1:end-1); #[0,2*pi)
  ## phase/amp parameters for some SU(2) operators
  params = [kron(amp,ones(length(pha)^2,1)),...
            kron(ones(length(amp),1),kron(pha,ones(length(pha),1))),...
            kron(ones(length(amp)*length(pha),1),pha)];

  ## write parameters to file
  save(logname,"params");

  su2s = cell(1,rows(params));
  for j = 1:length(su2s);
    ## current SU(2) op
    su2s{j} = U2phaseamp(params(j,:));
  endfor

  ## write operators to file
  save("-append",logname,"su2s")

  ## clean up
  clear all;
  rmpath("../qcs/inst:../qcs/inst/@QIASMsingle/private");

endfunction
