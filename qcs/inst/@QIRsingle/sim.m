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
## @deftypefn {Function File} {[@var{y},@var{t}] =} sim (@var{g},@var{in},@var{b},@var{d},@var{dl},@var{ct},@var{tl})
##
##  Users should not simulate gates. Just circuits using the simulate function.
##
##  simulate the action of a @@QASMsingle @var{g} on pure state
##  @var{in} in a system of size @var{b} qubits.  The current simulation depth is
##  @var{d} and @var{dl} is the user specified simulation depth limit.
##  Similarly, @var{ct} is the current simulation time step (w.r.t to
##  dl) and @var{tl} is the user specified number of steps to simulate.
##  The simulation returns two results, the pure state y that results
##  from the operation and the current time step t.
##
## @seealso{simulate}
##
## @end deftypefn

## Author: Logan Mayfield
## Keyword: QIR

function [y,t] = sim(gate,in,bits,currd,dlim,currt,tlim)

  op = circ2mat(gate,bits);

  ## compute output state
  y = op*in;

  ## time steps update, or not
  if( currd <= dlim )
    t = currt+1;
  elseif( currd > dlim )
    t = currt;
  endif

endfunction


## Exact tests used for @single. Given that circ2mat works as expected,
##  it's not really necessary to do a detailed test of results here as this
##  implentation is essentially the textbook definition.

%!test
%! lH = sqrt(1/2)*[1,1;1,-1];
%! lX = [0,1;1,0];
%! lY = i*[0,-1;1,0];
%! lZ = [1,0;0,-1];
%! lS = [1,0;0,i];
%! lT = [1,0;0,e^(i*pi/4)];
%! in = (0:7==1)';
%! ops = {"X","Y","Z","H","S","S'","T","T'"};
%! mats = {lX,lY,lZ,lH,lS,lS',lT,lT'};
%!
%! ## all ops, currd < dlim
%! for o = 1:length(ops)
%!   for tar = 0:2
%!      [y,t] = sim(@QIRsingle(ops{o},tar),in,3,1,2,0,5);
%!      assert(t==1);
%!      curOp = kron(speye(2^(3-tar-1)),kron(mats{o},speye(2^tar)));
%!      assert(isequal(y,curOp*in));
%!   endfor
%! endfor
%!
%! ## all ops currd = dlim
%! for o = 1:length(ops)
%!   for tar = 0:2
%!      [y,t] = sim(@QIRsingle(ops{o},tar),in,3,1,1,0,5);
%!      assert(t==1);
%!      curOp = kron(speye(2^(3-tar-1)),kron(mats{o},speye(2^tar)));
%!      assert(isequal(y,curOp*in));
%!   endfor
%! endfor
%!
%! ## all ops, currd > dlim
%! for o = 1:length(ops)
%!   for tar = 0:2
%!      [y,t] = sim(@QIRsingle(ops{o},tar),in,3,3,2,0,5);
%!      assert(t==0);
%!      curOp = kron(speye(2^(3-tar-1)),kron(mats{o},speye(2^tar)));
%!      assert(isequal(y,curOp*in));
%!   endfor
%! endfor
%!
