
#Signature: PPRM: int n
#Purpose: Recursivly kronikers PPRM n times
#Pre-Condition: Must take a integer greater than 0
#Post-Condition: Yields a matrix
function Mn = PPRM(n)
  Mn = [1];
  M1 = [1,0;1,1];
  for i = 1:n
    Mn = kron(Mn,M1);
  endfor
endfunction


#The test makes sure that a PPRM of 2 bits properly displays the correct output.
%!test
%! PPRM2  = [1,0,0,0;1,1,0,0;1,0,1,0;1,1,1,1];
%! bits = 2;
%! expect = PPRM(2);
%! assert(PPRM2,expect);

%!demo
%!  bits = 2;
%!  PPRM(2)
%! %-------------------------------------------------
%! % Demonstrates the output of a call to PPRM with 2 bits.
