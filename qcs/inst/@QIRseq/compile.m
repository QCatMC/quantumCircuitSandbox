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
##  Computes a @@QIASMseq that approximates @@QIRseq @var{g} to within
##  @var{e}. Users should use qcc for all circuit/gate compilation.
##
## @seealso{qcc}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR


function q = compile(this)

  seq = get(this,"seq");
  s = cell(length(seq),1);
  for k = 1:length(s)
    s{k} = compile(seq{k});
  endfor

  q = @QIASMseq(s);

endfunction

%!test
%! c = {@QIRsingle("H",0),@QIRsingle("H",1)};
%! C = @QIRseq(c,@QIRseq(c));
%! r = {@QIASMsingle("H",0),@QIASMsingle("H",1)};
%! R = @QIASMseq(r,@QIASMseq(r));
%! assert(eq(compile(C),R));
