
#Signature: makereversiblePPRM: matrix m int nbit
#Purpose: Creates a reversible PPRM from a Reversible Minterm
#Pre-Condition: Must take a matrix representing the reversible minterm
#Post-Condition: Yields a matrix representing the reversible PPRM
function Mn = makereversiblePPRM(m, nbit)
  step1 = makereversibleunsortedPPRM(m);
  Mn = sortreversiblePPRM(step1, nbit);
endfunction

#Tests the make reversible PPRM fuction to the expected results for xor.
%!test
%! PPRMxor = [0,0,0;1,0,1;0,1,1;0,0,1;0,0,0;0,0,0;0,0,0;0,0,0];
%! xor  = [0;1;1;0];
%! bits = 3;
%! revmin = makereversiblemin(xor);
%! expect = makereversiblePPRM(revmin, bits);
%! assert(PPRMxor,expect);

%!demo
%! xor  = [0;1;1;0];
%! bits = 3;
%! revmin = makereversiblemin(xor);
%! makereversiblePPRM(revmin, bits)
%! %-------------------------------------------------
%! % Demonstrates the output making a full pprm expression for the xor boolean function. 
