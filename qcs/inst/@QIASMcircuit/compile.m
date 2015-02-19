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
## @deftypefn {Function File} {@var{C} =} compile (@var{C},@var{ETA})
##
## Approximate @var{C} to within an error of @var{ETA} with a @QASMcircuit
## Users should not use this directly, but should instead use the
## quantum circuit compiler (qcc)
##
##
## @seealso{qcc}
##
## @end deftypefn


## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function q = compile(this,eta)
  ## to achieve eta precision we must approximate each non-elementary
  ## operator to precision eta/m, where m is the number of
  ## non-elementary operators in the circuit.

  if( this.numtoapprox == 0 )
    q = @QASMcircuit(compile(get(this,"seq"),eta),get(this,"bits"));
  else
    ## load in global var UZERO
    ## This is a 2D cell array that contains precomputed
    ## sequences used as initial approximations

    ## build path off full path to this file
    uzpath = sprintf("%s/private/uzero.mat",fileparts (mfilename ("fullpath")));

    load(uzpath); # load

    opEta = eta/this.numtoapprox;
    q = @QASMcircuit(compile(get(this,"seq"),opEta),get(this,"bits"));

    ## clear global data table
    clear -g UZERO;
  endif

endfunction

## very basic tests to be sure things get dispatched right.
##  accuracy/correctness is tested deeper in the hierarchy
%!test
%! assert(eq(@QASMcircuit(@QASMseq({@QASMsingle("H",0)})),...
%!        compile(@QIASMcircuit(@QIASMseq({@QIASMsingle("H",0)})),1/16)));
%! assert(isa(compile(@QIASMcircuit(@QIASMseq({@QIASMsingle("PhAmp",0,[pi,pi/2,pi/3,pi/4])})),1/8), ...
%!        "QASMcircuit"));
