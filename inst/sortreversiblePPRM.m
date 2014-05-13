
#Signature: sortreversiblePPRM: matrix unsortedPPRM int nbit
#Purpose: Sorts a reversible PPRM into the correct order based on the number of bits.
#Pre-Condition: Must take a matrix representing the unsorted PPRM
#Post-Condition: Yeilds a matrix representing the sorted reversible PPRM
function Mn = sortreversiblePPRM(unsortedPPRM, nbit)
Mn = eye(2^nbit)(MinToPPRMOrder(nbit),:)* unsortedPPRM;
endfunction

#Tests the sorting of a reversible PPRM for the XOR boolean function, using 3 bits.
%!test
%! sortedrevPPRMxor = [0,0,0;1,0,1;0,1,1;0,0,1;0,0,0;0,0,0;0,0,0;0,0,0];
%! xor  = [0;1;1;0];
%! bits = 3;
%! revmin = makereversiblemin(xor);
%! revunsortedPPRM = makereversibleunsortedPPRM(revmin);
%! expect = sortreversiblePPRM(revunsortedPPRM, bits);
%! assert(sortedrevPPRMxor,expect);

%!demo
%! xor  = [0;1;1;0];
%! bits = 3;
%! revmin = makereversiblemin(xor);
%! revunsortedPPRM = makereversibleunsortedPPRM(revmin);
%! sortreversiblePPRM(revunsortedPPRM, bits)
%! %-------------------------------------------------
%! % Demonstrates the output of sorting a reversible unsorted PPRM expression for the xor term.
