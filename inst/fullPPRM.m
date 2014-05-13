 
#Signature: fullPPRM: vector vector int nbit -> Matrix
#Purpose: Takes a vector and its number of bits and creates a revesible PPRM
#Pre-Condition: Takes a vector reprenting a boolean bunction and a integer 
#               representing the number of bits. 
#Post-Condition: Yields a matrix representing the full PPRM expansion. 
function Mn = fullPPRM(vector, nbit)
  step1 = makereversiblemin(vector);
  Mn = makereversiblePPRM(step1, nbit);
endfunction

%!test
%! PPRMxor = [0,0,0;1,0,1;0,1,1;0,0,1;0,0,0;0,0,0;0,0,0;0,0,0];
%! xor = [0;1;1;0];
%! bits = 3;
%! expect = fullPPRM(xor, bits);
%! assert(PPRMxor,expect);

%!demo
%! xor = [0;1;1;0];
%! bits = 3;
%! fullPPRM(xor, bits)
%! %-------------------------------------------------
%! % Demonstrates the output making a full pprm expression for the xor boolean function
