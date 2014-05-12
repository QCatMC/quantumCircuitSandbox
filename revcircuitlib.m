PPRMlib;


#Signature: RandomVector: int n
#Purpose: Takes a number that signifies the # of bit and returns a random n bit vector
#Pre-Condition: Must take a integer greater than 0
#Post-Condition: Yields a vector
function Mn = RandomVector(n)
  Mn = discrete_rnd([0,1],[1/2,1/2],(2^n),1);
endfunction

#The test tests whether the size of the Random Vector is equivilant to the size that is supposed to be created. 
%!test
%! vsize = [4,1];
%! bits = 2;
%! expect = size(RandomVector(bits));
%! assert(vsize,expect);

%!demo
%!  bits = 2;
%!  RandomVector(bits)
%! %-------------------------------------------------
%! % the figure shows a 2 bit random vector generation


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


#Signature: bin: int n, int b
#Purpose: Develops a binary vector of numbers that stems from the current row int n and the n-bit integer b. 
#Pre-Condition: Must input a number that can fit in the binary bits allowed
#Post-Condition: Yields an array of numbers
function Mn = bin(n,b)

  binny = dec2bin(n,b);

b = zeros(1, length(binny));
for i = 1:length(binny)
	  b(1,i) = str2num(binny(i));
endfor
Mn = b;

endfunction

#Test shows that the function properly displays the number in the correct 
#number of bits.
%!test
%! twointhree  = [0,1,0];
%! number = 2;
%! bits = 3;
%! expect = bin(number,bits);
%! assert(twointhree,expect);

%!demo
%!  number = 2;
%!  bits = 3;
%!  bin(number,bits)
%! %-------------------------------------------------
%! % Demonstrates the binary output of the number 2 in 3 bits.

#Signature: makereversiblemin: vector n
#Purpose: takes a vector and returns the reversible Minterm
#Pre-Condition: Must take a proper vector
#Post-Condition: Yields a matrix
function Mn = makereversiblemin(n)
  mat = zeros(2*rows(n),log2(rows(n))+1);
 
 for i = 1:rows(n)
	   for j = 1:2
	             newrow = [bin(i-1,log2(rows(n))), xor(n(i,1),(j-1))];
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

#Signature: fullRandomPPRM: int nbit -> Matrix
#Purpose: Creates a PPRM for a random nbit function.
#Pre-Condition: Must take a proper integer greater than 0.
#Post-Condition: Yields a matrix representing the PPRM for a fully randomized boolean output 
function Mn = fullRandomPPRM(nbit)
step1 = RandomVector(nbit)
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
