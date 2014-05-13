## usage: b = stdBasis(i,n)
##
## Compute the n qubit standard basis corresponding to
## the natural number i and return it as a 2^n column
## vector of type

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: States

function b = stdBasis(i,n,type="double")
  validTypes = ["double";"complex";"single";"int";"logical"];	 

  tVal = strmatch(type,validTypes,"exact");

  if( i < 0 || i > (2^n-1) )
    error("i must be in [0,%d). Given i=%d",2^n,i);    
  elseif( size(tVal) != [1,1] )
    error("type not supported");
  endif
  
  tVal = tVal(1);
  b = [0:(2^n -1 )]' == i;
  
  if( tVal  == 1 )
    b = double(b);
  elseif( tVal == 2 )
    b = complex(b);
  elseif( tVal == 3 )
    b = single(b);
  elseif( tVal == 4 )
    b = uint8(b);
  endif
  # else leave it as logical

end

