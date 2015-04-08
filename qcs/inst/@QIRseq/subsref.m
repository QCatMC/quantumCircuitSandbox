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
## @deftypefn {Function File} {@var{C} =} subsref (@var{C},@var{idx})
##
## Select subsequence of sequence @var{C}.
##
##  @var{C}(a,b) selects steps a with respect to ndepth d.
## The steps argument, a may be
## a vector of positive integers where the ndepth argument d must be
## a positive integer scalar.
##
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function C = subsref(this,idx)
  C = @QIRseq();
  C.seq = subsref(this.seq,idx);
endfunction

%!test
%! S = @QIRseq({QIR("H",2),QIR("X",3),QIR("CNot",0,2)});
%! assert(eq(@QIRseq({QIR("X",3)}), S(2)));
%! S = @QIRseq({QIR("H",2),QIR("X",3),QIR("CNot",0,2)});
%! assert(eq(S, S(1:3)));
