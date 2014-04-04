PPRMlib;


#Signature: RandomVector: int n
#Purpose: Takes a number that signifies the # of bit and returns a random n bit vector
function Mn = RandomVector(n)
  Mn = discrete_rnd([0,1],[1/2,1/2],(2^n),1);
endfunction

#Signature: PPRM: int n
#Purpose: Recursivly kronikers PPRM n times
function Mn = PPRM(n)
Mn = [1];
M1 = [1,0;1,1];
for i = 1:n
	  Mn = kron(Mn,M1);
endfor
endfunction

#Signature: bin: int n, int b
#Purpose: Develops a binary vector of numbers that stems from the current row int n and the n-bit integer b. 
function Mn = bin(n,b)

  binny = dec2bin(n,b);

b = zeros(1, length(binny));
for i = 1:length(binny)
	  b(1,i) = str2num(binny(i));
endfor
Mn = b;

endfunction

#Signature: makereversiblemin: vector n
#Purpose: takes a vector and returns the reversible Minterm
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

#Signature: makereversiblePPRM: matrix m
#Purpose: Creates a reversiblePPRM that is not sorted in the correct order
function Mn = makereversibleunsortedPPRM(m)
mat = zeros(rows(m),columns(m));

T = PPRM(log2(rows(m)));
for i = 1:columns(m)
    mat(:,i) = T*m(:, i);
endfor

Mn = mod(mat,2);

endfunction

#Signature: sortreversiblePPRM: matrix unsortedPPRM int nbit
#Purpose: Sorts a reversible PPRM into the correct order based on the number of bits.
function Mn = sortreversiblePPRM(unsortedPPRM, nbit)
Mn = eye(2^nbit)(MinToPPRMOrder(nbit),:)* unsortedPPRM;
endfunction

#Signature: makereversiblePPRM: matrix m int nbit
#Purpose: Creates a reversible PPRM from a Reversible Minterm
function Mn = makereversiblePPRM(m, nbit)
step1 = makereversibleunsortedPPRM(m);
Mn = sortreversiblePPRM(step1, nbit);
endfunction

#Signature: fullRandomPPRM: int nbit -> Matrix
#Purpose: Creates a PPRM for a random nbit function.
function Mn = fullRandomPPRM(nbit)
step1 = RandomVector(nbit)
step2 = makereversiblemin(step1);
Mn = makereversiblePPRM(step2, nbit+1);
endfunction


#Signature: fullPPRM: vector vector int nbit -> Matrix
#Purpose: Takes a vector and its number of bits and creates a revesible PPRM
function Mn = fullPPRM(vector, nbit)
step1 = makereversiblemin(vector);
Mn = makereversiblePPRM(step1, nbit);
endfunction
