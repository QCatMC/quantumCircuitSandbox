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

## usage: [i,s] = stdMeasure(q)
##
## Perform a complete measurement in the standard basis of the state
## q where q can either be  a vector or a density matrix. Both the integer and 
## state vector of the result are returned. 
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: States

function [s,i] = stdMeasure(q,t=[])
  n = log2(length(q));
  
  ##complete measurement
  if( isequal(t,[]) || isequal(t,[0:n-1]) )
    pmf = zeros(n);
    if( rows(q) == columns(q) ) 
      pmf = diag(q);
    else
      pmf = q .* conj(q);
    endif
    ## get result
    i = discrete_rnd([0:length(q)-1],pmf,1);
    ## compute basis of result
    s = stdBasis(i,log2(length(q)));
  ## partial measurement
  else
    if( !isTargetVector(t) )
      error("Bad Measurement targets.");
    endif
  
    i = 0;
    s = stdBasis(0,log2(length(q)));
  

  endif

endfunction

%!test
%! x = stdBasis(5,3);
%! for i = 1:30
%!  [s,j] =  stdMeasure(x);
%!  assert(j,5);
%!  assert(s,stdBasis(5,3))
%! endfor
%! for i = 1:30
%!  [s,j] =  stdMeasure(pureToDensity(x));
%!  assert(j,5);
%!  assert(s,stdBasis(5,3))
%! endfor

### better testing here?
%!test
%! x = 1/2*[1,-1,1,-1]';
%! res = zeros(4,1); 
%! for i = 1:250
%!   [s,r] = stdMeasure(x);
%!   res(r+1) = res(r+1) + 1;
%! endfor
%! res = res ./ 250;
%! assert(1/4,mean(res))
