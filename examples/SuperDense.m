1;

pkg load oct-circuits;

## Like many quantum circuits, Super Dense Coding circuits really vary by just a few 
## key operators.  The four Super-Dense coding circuits all take |00> as the input, then
##  transfor to the bell basis 00. Alice then performs her operations on
##  bit 1.  Bob can then measure in the bell basis by way of transforming
##  back to the std basis and doing a standard measurement. So, we can write a basic octave 
## function to construct circuit arrays given the names of the operators applied by Alice.

## Constructor for SuperDense Coding circuit descriptor
function C = makeSDCirc(alice)
  ## the Std to Bell basis transform
  trans = {{"H",1},{"CNot",0,1}};

  ## the SDC starts with a basis change
  C = trans;
  ## then apply each of Alice's operators
  for k = 1:length(alice)
    C = {C{:},{alice(k),1}};
  endfor	 
  ## then change the basis back and Measure
  C = {C{:},fliplr(trans){:},{"Measure",0:1}};
endfunction

## Encode 00
ZrZr = makeSDCirc(["I"]);

## Encode 01
ZrOn = makeSDCirc(["X"]);

## Encode 10
OnZr = makeSDCirc(["Z"]);

## Encode 11
OnOn = makeSDCirc(["X","Z"]);

## Now let's try all 4... 100 times
tot = zeros(4,4);
for k = 1:100
  res = zeros(4,4);
  res(:,1) = simulate(buildQASMcircuit(ZrZr),0);
  res(:,2) = simulate(buildQASMcircuit(ZrOn),0);
  res(:,3) = simulate(buildQASMcircuit(OnZr),0);
  res(:,4) = simulate(buildQASMcircuit(OnOn),0);
  tot = tot + res;
endfor

## and the sample mean...
tot = tot/100


