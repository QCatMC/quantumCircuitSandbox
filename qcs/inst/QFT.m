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
## @deftypefn {Function File} {@var{C} =} QFT (@var{n})
##
## Compute the QIR circuit for an @var{n} qubit quantum fourier transform.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function C = QFT(n)
  C = revOrder(n);
  for k = 0:(n-1)
    Q = [QIR,QIR("H",k)];
    for l = (k+1):(n-1)
      Q = [Q,consCRk(l-k+1,k,l)];
    endfor
    C = [C,Q];
  endfor
endfunction

## Create Controlled-Rk with target t and control c
function rk = consCRk(k,t,c)
  v = Rk(k,t);
  if( k < 4 )
    rk = QIR("CU",get(v,"name"),t,c);
  else
    rk = QIR("CU",{get(v,"name"),get(v,"params")},t,c);
  endif
endfunction

## Revere qubit order
function C = revOrder(n)
  C = QIR;
  if( n > 1 )
    for k = floor(n/2):(n-1)
      if( (n-1-k) != k )
        C =[C,QIR("Swap",(n-1)-k,k)];
      endif
    endfor
  endif

endfunction

%!function Q = qft(n)
%!  Q = (1/sqrt(2^n))*ones(2^n);
%!  for k = 2:2^n
%!    for j = 2:2^n
%!      Q(k,j) = Q(k,j)*e^(2*pi*i/(2^n))^(mod((j-1)*(k-1),2^n));
%!    endfor
%!  endfor
%!endfunction

%!test
%! for l = 1:8
%!  U = full(circ2mat(QFT(l)));
%!  V = qft(l);
%!  err = operr(U,V);
%!  assert(err < 2^(-30), "%f ",err );
%! endfor
