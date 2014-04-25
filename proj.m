# project to a subspace of x where the t'th bit is b, i.e.
# zero out all locations where t^th bit is !b
function y = proj(x,t,b,n)

  #error checking
  if( b < 0 || b > 1) #bad projector value
    error("b must be 0 or 1. b=%d",b);
  elseif ( t>=n || t<0 ) #bad target
    error("bad target. must be in [0,n). t=%d n=%d",t,n);
  elseif ( length(x) != 2^n ) # bad vector/bit combo
	 error("vector/dimension mismatch length(x) must be 2^n. n=%d. len=%d",n,length(x));
  endif

  # project by reshaping and masking
  X = reshape(x,2^(t),2,2^(n-t-1));
  mask = [ones(2^(t),1,2^(n-t-1)),zeros(2^t,1,2^(n-t-1))];
  
  # swap 1s and 0s for projection to b==1
  if( b == 1 )
    mask = flipdim(mask,2);
  endif

  # mask
  X = X .* mask;
  y = reshape(X,2^n,1);

endfunction

%!test
%! P = zeros(8,6);
%! for i = 0:2
%!  P(:,2*i+1) = proj(ones(8,1),i,0,3);
%!  P(:,2*i+2) = proj(ones(8,1),i,1,3);
%! endfor
%! x=[0:7]';
%! expect = double([sum(x==[0,2,4,6],2),sum(x==[1,3,5,7],2), ...
%!                  sum(x==[0,1,4,5],2),sum(x==[2,3,6,7],2), ... 
%!                   x<4,x>3]); 
%! assert(P,expect);
