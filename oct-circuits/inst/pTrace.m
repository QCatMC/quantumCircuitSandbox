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

## Usage: Q = pTrace(r,P)
## 
## Trace out the space of bits r in the state represented by 
## density matrix P.  
##
## For n bit state, r is either [0,m] or [m,n) for 0<m<n

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: States

function Q = pTrace(r,P)
  numBits = log2(rows(P));

  if( length(r) > numBits )
    error("Trace out space too large");
  elseif( length(r) == numBits )
    error("Did you mean a complete trace?");
  endif

  outSize = 2^(length(r)); #size of traced out space
  inSize = 2^(numBits-length(r)); #size of remaining space 



  Q = zeros(inSize,inSize); # allocate result


  if( r(1) == 0 ) # low order bitspace
    ## collect blocks
    blocks = zeros(outSize,outSize,numel(P)/(outSize^2));  
    for i = 1:(inSize^2)
      row =  floor(((i-1)/inSize))+1; # row number in block matrix
      col =  i-((row-1)*inSize); # col number in block matrix
      blocks(:,:,i) = P((row-1)*outSize+1:row*outSize, ...
			(col-1)*outSize+1:col*outSize);
    endfor
    
    # trace out
    q = zeros(1,size(blocks)(3));
    for i = 1:length(q)
      q(i) = trace(blocks(:,:,i));
    endfor
    Q = reshape(q,inSize,inSize);

  elseif( r(length(r)) == numBits-1 ) # high order bit space
    ## collect blocks
    blocks = zeros(inSize,inSize,numel(P)/(inSize^2));  
    for i = 1:(outSize^2)
      row =  floor(((i-1)/outSize))+1; # row number in block matrix
      col =  i-((row-1)*outSize); # col number in block matrix
      blocks(:,:,i) = P((row-1)*inSize+1:row*inSize, ...
			(col-1)*inSize+1:col*inSize);
    endfor
    
    ## trace out
    for i = [1:outSize]
      Q = Q + blocks(:,:,((i-1)*outSize)+i);
    endfor
  endif

endfunction
