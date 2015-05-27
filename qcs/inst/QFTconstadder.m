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
## @deftypefn {Function File} {@var{C} =} constadder (@var{n})
##
## Compute the circuit for doing QFT addition (modulo 2^n) of the constant @var{c}
## to the an @var{n} qubit state.
##
## @seealso{QFT}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function C = QFTconstadder(c,n)
  cbin = fliplr(binaryrep(c,n));
  C = QIR;
  for j = n-1:-1:0
    Aj = QIR;
    for k = (j+1):-1:1
      if( cbin(j+2-k) == 1 )
        Aj =[Aj,Rk(k,(n-1-j))];
      endif
    endfor
    C = [C,Aj];
  endfor
endfunction

%!test
%! in = 1;
%! const = 3;
%! bits = 4;
%! C = [QIR,QFT(bits),QFTconstadder(const,bits),QFT(bits)'];
%! act = simulate(C,in,"samples",1,"classicalout","Int");
%! assert(act == in+const,"expected %d. got %d",in+const,act);
