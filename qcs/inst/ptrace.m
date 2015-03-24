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
## @deftypefn {Function File} {@var{Q} =} ptrace (@var{r},@var{P})
##
## Perform a partial trace over the qubit space @var{r} of the quantum state @var{P}.
##
## Where @var{P} is a @math{n} qubit quantum state and @var{r} is either @code{0:m} or @code{m:(n-1)} for @math{0<m<n}, then a partial trace of the qubit space specified by @var{r} is performed. State @var{P} can be either a pure state vector or a density matrix. The result @var{Q} is always a density matrix.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: States

function Q = ptrace(r,P)
  numBits = log2(rows(P));

  if( length(r) > numBits ) # too many bits?
    error("Trace out space too large. Given [%d,%d]. Space is \
				%%[%d,%d)", ...
	  r(1),r(length(r)),0,numBits);
  elseif( length(r) > 1 && !isequal(diff(r),ones(1,length(r)-1)) ) # not a sequence
    error("Trace out space must be sequential and increasing");
  elseif( r(1) != 0 && r(length(r)) != numBits-1 )
    error("Only regions beginning at least or greatest bit allowed");
  endif

  ## vector... convert to density matrix
  if( columns(P) == 1 )
    P = puretodensity(P);
  endif

  ## get sizes of subspaces
  outBits = length(r);
  outSize = 2^(outBits); #size of traced out space

  inBits = numBits-outBits;
  inSize = 2^(numBits-length(r)); #size of remaining space

  Q = zeros(inSize,inSize); # allocate result space

  if( length(r) == numBits ) #complete trace
    Q = trace(P);
  elseif( r(1) == 0 ) # low order bitspace
    blocks = zeros(outSize,outSize,inSize^2);   #allocate space

    ## collect blocks
    for i = 1:(inSize^2)
      row =  floor(((i-1)/inSize))+1; # row number in block matrix
      col =  i-((row-1)*inSize); # col number in block matrix
      ## get the ith block
      blocks(:,:,i) = P((row-1)*outSize+1:row*outSize, ...
			(col-1)*outSize+1:col*outSize);
    endfor

    # trace out each block
    q = zeros(1,inSize^2);
    for i = 1:length(q)
      q(i) = trace(blocks(:,:,i));
    endfor
    # reshape to density matrix
    Q = transpose(reshape(q,inSize,inSize));

  elseif( r(length(r)) == numBits-1 ) # high order bit space
    ## collect blocks
    blocks = zeros(inSize,inSize,outSize^2);
    for i = 1:(outSize^2)
      row =  floor(((i-1)/outSize))+1; # row number in block matrix
      col =  i-((row-1)*outSize); # col number in block matrix
      ## collect ith Block
      blocks(:,:,i) = P((row-1)*inSize+1:row*inSize, ...
			(col-1)*inSize+1:col*inSize);
    endfor

    ## trace out by summing diagonal blocks
    for i = [1:outSize]
      Q = Q + blocks(:,:,((i-1)*outSize)+i);
    endfor

  endif

endfunction

%!test
%! X = transpose(reshape([1:16]',4,4));
%! low = [7,11;23,27];
%! high = [12,14;20,22];
%! assert(low,ptrace([0],X));
%! assert(high,ptrace([1],X));
%! assert(trace(X),ptrace(0:1,X));
