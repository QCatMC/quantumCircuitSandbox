

bitTricks;

function v = MinToPPRMOrder(n)

  [s,i] = sort(hamWeight(2^n-1:-1:0));
  v = flipud(i)';

end


  

	
