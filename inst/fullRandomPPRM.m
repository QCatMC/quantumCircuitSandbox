
#Signature: fullRandomPPRM: int nbit -> Matrix
#Purpose: Creates a PPRM for a random nbit function.
#Pre-Condition: Must take a proper integer greater than 0.
#Post-Condition: Yields a matrix representing the PPRM for a fully randomized boolean output 
function Mn = fullRandomPPRM(nbit)
  step1 = RandomFVector(nbit)
  step2 = makereversiblemin(step1);
  Mn = makereversiblePPRM(step2, nbit+1);
endfunction

# Tests the size comparison for the expected output matrix for the 
# PPRM expansion as compared to what the size should be.
%!test
%! msize = [8,3];
%! bits = 2;
%! expect = size(fullRandomPPRM(bits));
%! assert(msize,expect);

%!demo
%! bits = 2;
%! fullRandomPPRM(bits)
%! %-------------------------------------------------
%! % Demonstrates the output making a full pprm expression for a random input boolean function vector.
