1;

pkg load qcs;

## Like many quantum circuits, Super Dense Coding circuits really vary by just a few
## key operators.  The four Super-Dense coding circuits all take |00> as the input, then
##  transfor to the bell basis 00. Alice then performs her operations on
##  bit 1.  Bob can then measure in the bell basis by way of transforming
##  back to the std basis and doing a standard measurement. So, we can write a basic octave
## function to construct circuit arrays given the names of the operators applied by Alice.

## Constructor for SuperDense Coding circuit descriptor
function C = makeSDCirc(alice)
  ## the Std to Bell basis transform
  trans = [QIR("H",1),QIR("CNot",0,1)];

  ## Now we'll build a circuit for Alice's
  ## operators
  A = QIR;
  ## then apply each of Alice's operators
  for k = 1:length(alice)
    A = [A,QIR(alice{k},1)];
  endfor

  ## the complete circuit
  ##  std->bell, Encode, bell->std, measure
  ## the QIR in front forces trans to be a nested
  ## subcircuit
  C = [QIR,trans,A,trans',QIR("Measure",0:1)];
endfunction

## Encode 00
ZrZr = makeSDCirc({})

## Encode 01
ZrOn = makeSDCirc({"X"})

## Encode 10
OnZr = makeSDCirc({"Z"})

## Encode 11
OnOn = makeSDCirc({"X","Z"})

## Now let's try all 4... 100 times
tot = zeros(4,4);
for k = 1:100
  res = zeros(4,4);
  res(:,1) = simulate(ZrZr,0);
  res(:,2) = simulate(ZrOn,0);
  res(:,3) = simulate(OnZr,0);
  res(:,4) = simulate(OnOn,0);
  tot = tot + res;
endfor

## and the sample mean...
tot = tot/100
