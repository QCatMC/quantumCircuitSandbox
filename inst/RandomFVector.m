#Signature: RandomFVector: int n 
#Purpose: Takes a number that signifies the # of bit and returns a random n bit vector
#Pre-Condition: Must take a integer greater than 0
#Post-Condition: Yields a vector
function Mn = RandomFVector(n)
  Mn = discrete_rnd([0,1],[1/2,1/2],(2^n),1);
endfunction

#The test tests whether the size of the Random Vector is equivilant to the size that is supposed to be created. 
%!test
%! vsize = [4,1];
%! bits = 2;
%! expect = size(RandomFVector(bits));
%! assert(vsize,expect);

%!demo
%!  bits = 2;
%!  RandomFVector(bits)
%! %-------------------------------------------------
%! % the figure shows a 2 bit random vector generation

