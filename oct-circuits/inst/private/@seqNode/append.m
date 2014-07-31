

function s = append(this,oth)
  s = @seqNode({ this{:},get(oth,"seq"){:}});
endfunction
