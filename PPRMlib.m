

bitTricks;

function v = MinToPPRMOrder(nbit)

  [s,i] = sort(hamWeight(2^nbit-1:-1:0));
  v = flipud(i)';

end
