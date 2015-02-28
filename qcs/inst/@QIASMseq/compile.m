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
##  Computes a @@QASMseq that approximates @@QIASMseq @var{g} to within
##  @var{e}. Users should use qcc for all circuit/gate compilation.
##
## @seealso{qcc}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function q = compile(this,eta)

  ts = get(this,"seq");
  s = cell(length(ts),1);
  for k = 1:length(s)
    s{k} = compile(ts{k},eta);
  endfor
  q = @QASMseq(s);

endfunction

## testing on all "H" gates as they're not likely to
##  change and we just need to test for proper traversal
##  and construction. testing for Approximation-based compilation
##  is done in @QIASMsingle/compile.m and @QIASMsingle/private/skalgo.m

%!test
%! c = {@QIASMsingle("H",0),@QIASMsingle("H",1)};
%! C = @QIASMseq(c,@QIASMseq(c));
%! r = {@QASMsingle("H",0),@QASMsingle("H",1)};
%! R = @QASMseq(r,@QASMseq(r));
%! assert(eq(compile(C,1/32),R));
