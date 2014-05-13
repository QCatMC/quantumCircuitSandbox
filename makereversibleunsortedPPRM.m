
#Signature: makereversibleunsortedPPRM: matrix m
#Purpose: Creates a reversiblePPRM that is not sorted in the correct order
#Pre-Condition: Must take a matrix represeting the reversible min
#Post-Condition: Creates a matrix representing the reversible PPRM
function Mn = makereversibleunsortedPPRM(m)
  mat = zeros(rows(m),columns(m));
  
  T = PPRM(log2(rows(m)));
  for i = 1:columns(m)
    mat(:,i) = T*m(:, i);
  endfor

  Mn = mod(mat,2);

endfunction

#Tests the reversible min function against the expected result using xor.
%!test
%! revunsortedPPRMxor = [0,0,0;0,0,1;0,1,1;0,0,0;1,0,1;0,0,0;0,0,0;0,0,0];
%! xor  = [0;1;1;0];
%! revmin = makereversiblemin(xor);
%! expect = makereversibleunsortedPPRM(revmin);
%! assert(revunsortedPPRMxor,expect);

%!demo
%! xor  = [0;1;1;0];
%! revmin = makereversiblemin(xor);
%! makereversibleunsortedPPRM(revmin)
%! %-------------------------------------------------
%! % Demonstrates the output of generating a reversible unsorted PPRM expression for the xor term.
