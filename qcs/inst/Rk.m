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
## @deftypefn {Function File} {@var{U} =} Rk (@var{k},@var{t})
##
## Compute a QIR single qubit gate targeting the qubits listed in set t
## and applying the phase shift matrix Rk(k) = [1,0;0,e^(i*2*pi/(2^k))].
##
## @seealso{QFT,QFTconstadder}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function U = Rk(k,t)

  if( !isnat(k) || !isscalar(k))
    error("Rk: parameter k must be a natural number.");
  elseif( !isnat(t) )
    error("Rk: parameter t must be a set of natural numbers.");
  endif

  switch (k)
    case 0
      U = QIR("I",t);
    case 1
      U = QIR("Z",t);
    case 2
      U = QIR("S",t);
    case 3
      U = QIR("T",t);
    otherwise
      p = Rnparams([1,0 ; 0,e^(2*i*pi/(2^k))]);
      U = QIR("Rn",p,t);
  endswitch


endfunction

%!test
%! fail('Rk(-1,0)');
%! fail('Rk(0,-1)');
%! fail('Rk(-1,-1)');
%! fail('Rk(1,3:-1:-2)');
%! assert(eq(Rk(0,1),@QIRsingle("I",1)));
%! assert(eq(Rk(1,1),@QIRsingle("Z",1)));
%! assert(eq(Rk(2,1),@QIRsingle("S",1)));
%! assert(eq(Rk(3,1),@QIRsingle("T",1)));
%! act = circ2mat(Rk(4,0),1);
%! exp = sqrt(T);
%! assert(operr(act,exp) < 2^-30);
