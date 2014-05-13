## Usage: y = applyOpTo(x,A,ts,n)
##
## apply the single qubit operator A to all the bits given
## in the vector ts. 
##  x is a 2^n column vector of a pure state
##  A is a 2 by 2 unitary matrix for the operator
##  ts is a vector of target bits 
##  n is the circuit size in bits
## based on paper by Kaushik, Gropp, Minkoff, and Smith

## Author: Logan Mayfield
## Keyword: Circuits

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
