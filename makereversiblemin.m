
#Signature: makereversiblemin: vector n
#Purpose: takes a vector and returns the reversible Minterm
#Pre-Condition: Must take a proper vector
#Post-Condition: Yields a matrix
function Mn = makereversiblemin(n)
  mat = zeros(2*rows(n),log2(rows(n))+1);
  
  for i = 1:rows(n)
    for j = 1:2
      newrow = [binaryRep(i-1,log2(rows(n))), xor(n(i,1),(j-1))];
      mat(2*(i-1)+j, :) = newrow;
    endfor                              
  endfor
  Mn = mat;
endfunction

#Tests the reversible min function against the expected result using xor.
%!test
%! revminxor = [0,0,0;0,0,1;0,1,1;0,1,0;1,0,1;1,0,0;1,1,0;1,1,1];
%! xor  = [0;1;1;0];
%! expect = makereversiblemin(xor);
%! assert(revminxor,expect);

%!demo
%! xor  = [0;1;1;0];
%! makereversiblemin(xor)
%! %-------------------------------------------------
%! % Demonstrates the generating of a reversible minterm using the xor boolean function.
