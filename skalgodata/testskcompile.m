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

## test on SK compilation on m randomly selected gates
## with gate level error et/m ... i.e. test results for
## a circuit with error <= et and m gates that need
## approximation

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM

function err = testskcompile(fname,et,m)

  ## load file and check for UZERO
  load(fname);
  if( !exist("UZERO") )
    error("no UZERO loaded from %s",fname);
  endif

  addpath("../qcs/inst:../qcs/inst/@QIASMsingle");

  errs =  zeros(m,1);

  for j = 1:m
    ## current SU(2) op U
    p = [unifrnd(0,pi/2,1,1),unifrnd(0,2*pi,1,2)];
    U = @QIASMsingle("PhAmp",0,p);
    V = compile(U,et/m);
    ## should be near the same up to a global phase
    Umat = full(circ2mat(U,1)); #already SU(2)
    Vmat = SUafy(full(circ2mat(V,1)));
    ## either we get gp*U or gp*-U
    errs(j) = min(norm(Umat-Vmat),norm(Umat+Vmat));
  endfor

  err = zeros(1,7);
  err(1) = sum(errs); # total error
  err(2) = err(1) - et; # diff with desired error
  err(3) = mean(errs); # avg error/gate
  err(4) = max(errs);  # max error/gate
  err(5) = min(errs); # min error/gate
  err(6) = sum(errs > (et/m)); # number above desired error
  err(7) = sum(errs < (et/m)); # number below desired error


  clear -g UZERO;
  rmpath("../qcs/inst:../qcs/inst/@QIASMsingle");


endfunction
