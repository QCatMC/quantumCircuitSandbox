

function y = applyOpTo(x,A,ts,n)
  
  if( size(A) != [2,2] )
    error("Operator must be Single Qubit (2x2). Given %dx%d",rows(A),columns(A));
  elseif( (rows(ts) != 1 || columns(ts) != 1) && ...
	  (length(ts) < 1 || length(ts) > n) )
    error("Target Vector size mismatch. Given %dx%d",rows(ts),columns(ts));
  elseif( 0 )
    error("Target Vector contains duplicate entries");
  endif

  for t = ts
      x = applyOp(x,A,t,n);
  end

  y=x;

endfunction
