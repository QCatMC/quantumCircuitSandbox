function y= CNot(x,c,t,n)

  # error checking
  if( c < 0 || c >= n || t < 0 || t >= n)
    error("Bad control or target. Must be in [0,n). n=%d c=%d t=%d",n,c,t);
  elseif ( length(x) != 2^n )
    error("Vector input size mismatch. len msut be 2^n. n=%d len=%d",n,length(x));
  elseif ( c == t )
    error("Control cannot be the same as target. c=%d t=%d",c,t);
  endif 
	 
  NOT = [0,1;1,0];
  a = proj(x,c,0,n); # get the unchanged, c=0 subspace
  b = applyOp(x,NOT,t,n); # apply not everywhere
  b = proj(b,c,1,n); # project result to c=1 space
  y=a+b; #sum the c=0 and c=1 spaces	 

endfunction

%!test
%!  x=[0:7]'==7;
%!  expect = (ones(8,6).*[0:7]') == [6,5,6,3,5,3];
%!  res = ones(8,6).*x;
%!  c = [2,2,1,1,0,0]'; 
%!  t = [0,1,0,2,1,2]';
%!  for i = [1:6]
%!     res(:,i) = CNot(res(:,i),c(i),t(i),3);
%!  endfor
%!  assert(res,double(expect));
