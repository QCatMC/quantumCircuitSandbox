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
## @deftypefn {Function File} {@var{s} =} measure (@var{q})
## @deftypefnx {Function File} {@var{s} =} measure (@var{q},@var{opt},@var{opt-val},...)
##
## Perform a complete measurement in the standard basis of a quantum state.
##
## Where @var{q} is a quantum state vector or density matrix, measure will perform a complete measurement in the standard basis on this state and return the resultant classical state. The @code{simulate} function can also carry out the same actions as @code{measure} by way of optional arguments. By default, @code{measure} performs a single measurement and @var{s} is the integer value of the corresponding classical state of @var{q} that results from that measurement. Optional arguments allow for multiple measurements and different formats for return values.
##
## The following options are allow with measure:
##
## ``binary''
## @quotation
## The ``binary'' option is either @code{true} or @code{false}. When it is @code{true} then for @math{n} qubit state @var{q}, the @math{n} bit binary representation of the classical state of each qubit is returned as a length @math{n} row vector. By default ``binary'' is @code{false} and integer values are returned.
## @end quotation
##
## ``samples''
## @quotation
## Then ``samples'' option can be any positive valued integer. When @math{s > 1} samples are taken, then the measurement is repeated @math{s} times and the majority result is returned. In the event of a tie, the leasted-valued majority result is returned. Only a single sample is taken by default.
## @end quotation
##
## @seealso{binaryRep,stdBasis,pureToDensity,simulate}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function res = measure(q,varargin)

  outBin = false;
  numSamps = 1;

  ## number of qubits
  n = log2(length(q));

  ## check for state vector
  if( n < 1 || floor(n) != ceil(n) || ...
     ((!isvector(q) || columns(q)!=1) && ...
      rows(q)!=columns(q)) )
    error("measure: Input does not seem to be a qubit state" );
  endif

  ## parse optionals, error check.
  if( !isempty(varargin) )

    [r,outBin,numSamps] = parseparams(varargin,"binary",false,"samples",1);

    if(outBin != true && outBin != false)
      error("measure: Binary Output argument must be true or false");
    endif

    if(!isNat(numSamps) || numSamps < 1)
      error("measure: Number of samples must be postive valued integer.");
    endif
  endif

  ## get pmf
  if( isvector(q) ) # state vector
    pmf = q .* conj(q);
  else  # density matrix
    pmf = diag(q);
  endif

  ## take samples
  samps = zeros(1,2^n);
  for k = 1:numSamps
    i = discrete_rnd([0:length(q)-1],pmf,1);
    samps(i+1)++;
  endfor

  ## majority rules
  [v,idx] = max(samps);
  ## offset index->integer
  res = idx-1;

  ## go binary if requested
  if( outBin )
    res = binaryRep(res,n);
  endif

endfunction

%!test
%! assert(measure(stdBasis(3,4)),3)
%! assert(measure(stdBasis(5,4)),5)
%! assert(measure(stdBasis(12,4)),12)
%! assert(measure(pureToDensity(stdBasis(3,4))),3)
%! assert(measure(pureToDensity(stdBasis(5,4))),5)
%! assert(measure(pureToDensity(stdBasis(13,4))),13)

%!test
%! assert(isequal(measure(stdBasis(3,4),"binary",true),binaryRep(3,4)))
%! assert(isequal(measure(stdBasis(5,4),"binary",true),binaryRep(5,4)))
%! assert(isequal(measure(stdBasis(7,4),"binary",true),binaryRep(7,4)))

%!test
%! assert(measure(stdBasis(6,5),"samples",5),6)
%! assert(measure(stdBasis(6,5),"samples",15),6)
%! assert(measure(stdBasis(6,5),"samples",25),6)
%! assert(measure(stdBasis(6,5),"samples",35),6)
%! assert(measure(stdBasis(6,5),"samples",55),6)

## need statistical tests
