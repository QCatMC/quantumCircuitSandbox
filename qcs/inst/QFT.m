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
## @deftypefn {Function File} {@var{C} =} QFTr (@var{n})
##
## Compute the QIR circuit for an @var{n} qubit quantum fourier transform.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function C = QFT(n)
  C = QIR;
  for k = 0:(n-1)
    Q = [QIR,QIR("H",k)];
    for l = (k+1):(n-1)
      Q = [Q,consCRk(l-k+1,k,l)];
    endfor
    C = [C,Q];
  endfor
endfunction

## Phase Change operator used in QFT circuits
function U = Rk(k)
   U = [1,0 ; 0,e^(2*i*pi/(2^k))];
endfunction

## Create Controlled-Rk with target t and control c
function rk = consCRk(k,t,c)
  rnp = RnParams(Rk(k));
  rk = QIR("CU",{"Rn",rnp},t,c);
endfunction
