
## test the correctness of UZERO
function errs = verifytable(tname)

  load(tname);
  tab = UZERO;
  clear -g UZERO;

  addpath ../qcs/inst/;

  errs = zeros(rows(tab),2); # error between computed seq and given SU

  for k = 1:rows(tab)
    seq = tab{k,1}; # current sequence
    SU = tab{k,2}; # current SU(2) operator
    SUinv = tab{tab{k,3},2}; ## the conjugate matrix for current SU


    seqU = eye(2); # computed operator from seq
    for l = 1:length(seq)
      seqU = seqU*eval(seq{l});
    endfor
    ## SU2afy the operator
    seqU = sqrt(det(seqU))' * seqU;

    errs(k,1) = norm(SU-seqU); # error bettween computed and table value
    errs(k,2) = norm((SU*SUinv)-eye(2)); # error for conjugate

  endfor

  off = find(errs(:,1) > 2^(-40) );
  numoff = length(off)
  invoff = find(errs(:,2) > 2^(-40) );
  numconjoff = length(invoff)

endfunction
