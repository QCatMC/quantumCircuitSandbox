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
## @deftypefn {Function File} {@var{C} =} compile (@var{g},@var{e})
##
##  Computes a sequence of @@QIASMcNot gates that is equivalent to
##  @QIRswap @var{g}.
##  Users should use qcc for all circuit/gate compilation.
##
## @seealso{qcc}
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR


function q = compile(this)
  t = get(this,"tar1");
  c = get(this,"tar2");

  q  = @QIASMseq({@QIASMcNot(t,c),...
                  @QIASMcNot(c,t),...
		              @QIASMcNot(t,c)});

endfunction

%!test
%! a = @QIRswap(0,1);
%! assert(isequal(circ2mat(compile(a),2),circ2mat(a,2)));
%! assert(isequal(circ2mat(compile(a),3),circ2mat(a,3)));
