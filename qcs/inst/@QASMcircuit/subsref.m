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
## Select subcircuit of circuit @var{C}.
##
##  @var{C}(a,b) selects
## steps a with respect to ndepth d. The steps argument, a maybe
## a vector of positive integers where the ndepth argument d must be
## a positive integer scalar.
##
## @end deftypefn


## Usage: C = subsref(this,idx)
##
## QASM circuit  sub-circuit selector


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QASM

function C = subsref(this,idx)
  ## do some error checking first or let the seq methods
  ##  catch it on the fly?

  ## select out the sub-sequence and construct with current
  ## number of bits
  C = @QASMcircuit(subsref(get(this,"seq"),idx),get(this,"bits"));

endfunction
