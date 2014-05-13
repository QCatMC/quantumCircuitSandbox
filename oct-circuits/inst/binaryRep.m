## usage: B = binaryRep(K,n)
##
## Compute the n bit binary representation of the natural
## numbers found in the vector K. The result is the 
## |K|x n martix where each row is the binary
## rep of the corresponding entry in K

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Misc

function b = binaryRep(k,n)
  b = zeros(length(k),n);
	 
  for j=1:length(k)
    b(j,:) = uint64(bitget(k(j),n:-1:1));
  endfor
end

%!test
%!  expect = [0,0,0; 0,0,1; 0,1,0; 0,1,1; ...
%!            1,0,0; 1,0,1; 1,1,0; 1,1,1];
%!  assert(expect, binaryRep([0:7],3));
