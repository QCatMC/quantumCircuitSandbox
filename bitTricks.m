1;

function r = hamWeight(n)

  shifts = [-1, -2, -4, -8, -16];
  masks = [1431655765, 858993459, 252645135, 16711935, 65535];

  r = zeros(length(n),1);
  for j=1:length(n)
    r(j) = n(j);
    for i=1:5
      r(j) = bitand(bitshift(r(j), shifts(i)), masks(i)) + ...
      bitand(r(j), masks(i));
    endfor
  endfor

end

function b = binaryRep(k,n)
  b = zeros(length(k),n);

  for j=1:length(k)
    b(j,:) = uint64(bitget(k(j),n:-1:1));
  endfor
end
