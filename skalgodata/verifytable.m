
## test the correctness of UZERO 
function errs = verifytable(tname)

  load(tname);
  tab = UZERO;
  clear -g UZERO;
  
  addpath ../oct-circuits/inst/;
  
  errs = zeros(1,rows(tab)); # error between computed seq and given SU

  for k = 1:rows(tab)
    seq = tab{k,1}; # current sequence
    SU = tab{k,2}; # current SU(2) operator
    
    
    seqU = eye(2); # computed operator from seq
    for l = 1:length(seq)
      seqU = seqU*eval(seq{l});
    endfor
    seqU = sqrt(det(seqU))' * seqU;
    
    errs(k) = norm(SU-seqU);

  endfor

  off = find(errs > 2^(-50))

endfunction
