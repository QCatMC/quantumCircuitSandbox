# Compute the permutation vector needed for rearranging
# an nbit PPRM representation of a boolean function that's 
# in minterm order to PPRM term order
function v = MinToPPRMOrder(nbit)

  [s,i] = sort(hamWeight(2^nbit-1:-1:0));
  v = flipud(i)';

end


  

	
