## Copyright (C) 2015  James Logan Mayfield
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
## @deftypefn {Function File} {@var{C} =} compile (@var{g},@var{e})
##
##  Computes a @@QIASMseq that is equivalent to @QIRccU @var{g}.
##  Users should use qcc for all circuit/gate compilation.
##
## @seealso{qcc}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR


function q = compile(this)
  t = get(this,"tar");
  c1 = get(this,"ctrls")(1);
  c2 = get(this,"ctrls")(2);
  op = get(this,"op");

  ##toffoli
  if( strcmp(op(1),"X") )
    q = @QIASMseq({@QIASMsingle("H",t),...
      @QIASMcNot(t,c2),...
      @QIASMsingle("T'",t),...
      @QIASMcNot(t,c1),...
      @QIASMsingle("T",t),...
      @QIASMcNot(t,c2),...
      @QIASMsingle("T'",t),...
      @QIASMcNot(t,c1),...
      @QIASMsingle("T",c2),@QIASMsingle("T",t),...
      @QIASMcNot(c2,c1),@QIASMsingle("H",t),...
      @QIASMsingle("T'",c2),...
      @QIASMcNot(c2,c1),...
      @QIASMsingle("T",c1)});
    else
      ## get the controlled operation's matrix
      U = zeros(2,2);
      if(length(op) == 1 )
          U = circ2mat(@QIRsingle(op{1},0),1);
      else
          U = circ2mat(@QIRsingle(op{1},0,op{2}),1);
      endif
      ## a square root of U and it's parameters
      V = (1/sqrt(trace(U)+2*sqrt(det(U))))*(sqrt(det(U))*speye(2) + U);
      vp = phaseampparams(V);

      q = @QIASMseq({ compile(@QIRcU(t,c2,{"PhAmp",vp})) ,...
                     @QIASMcNot(c2,c1) ,...
                      compile(@QIRcU(t,c2,{"PhAmp",phaseampparams(V')})) ,...
                     @QIASMcNot(c2,c1) , ...
                      compile(@QIRcU(t,c1,{"PhAmp",vp}))});
    endif

endfunction


## Toffoli case
%!test
%! a = @QIRccU(0,[2,1],{"X"});
%! A = circ2mat(a,3);
%! B = circ2mat(compile(a),3);
%! assert(operr(A,B) < 2^-32);

%!test
%! a = @QIRccU(0,[2,1],{"H"});
%! A = circ2mat(a,3);
%! B = circ2mat(compile(a),3);
%! assert(operr(A,B) < 2^-32);
