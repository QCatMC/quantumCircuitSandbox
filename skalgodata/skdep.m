
## given circuit eta et, number of gates to
## to approx m, and algorithm params eta0 (et0)
## and capprox (capp) get stats on
## the recursion depth needed by SK algo.
## maxd == depth for exactly m
## mind == depth for m=1
## meand == E[depth|m in [1,m-arg]]
## et0 and capp are set to current values found in
## @QIASMsingle/compile

function [maxd,mind,meand] = skdep(et,m,et0=.16,capp=1.9)

  ets = et*ones(1,m) ./ (1:m);
  deps = zeros(m,1);

  for k = 1:m
    deps(k) = recdep(ets(k),et0,capp);
  endfor

  maxd = max(deps);
  mind = min(deps);
  meand = mean(deps);

endfunction

## n samples of eta0,capp pairs
##  where eta0 is fixed and capp
## gets increasinly closer to the upper
## bound of sqrt(1/eta0)
function T = makeeta0capp(eta0,n)
  capp = sqrt(1/eta0);
  s = (0:(1/(n+1)):1)(2:end-1).';
  T = [eta0*ones(n,1),capp*s];
endfunction

## computes the recursion depth for
## SK given the parameter set
## eta, eta0, and capprox
function n = recdep(et,et0,capp)

  n = log( (log(1/(et*(capp^2))) /...
            log(1/(et0*(capp^2)))) / ...
          log(3/2) );
  n = ceil(n);

endfunction
