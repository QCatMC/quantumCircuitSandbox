1;

pkg load qcs;

## Like many quantum circuits, Super Dense Coding circuits really
## vary by just a few key operators.  The four Super-Dense coding
## circuits all take |00> as the input, then transform to the bell
## basis 00. Alice then performs her operations on bit 1.  Bob can
## then measure in the bell basis by way of transforming back to
## the std basis and doing a standard measurement. So, we can write
## a basic octave function to construct circuits given the names
## of the operators applied by Alice.

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
ZrZr = makeSDCirc({});

## Encode 01
ZrOn = makeSDCirc({"X"});

## Encode 10
OnZr = makeSDCirc({"Z"});

## Encode 11
OnOn = makeSDCirc({"X","Z"});

## Now let's try all 4. IT's a deterministic algorithm so
## we can do a single sample of the result. Let's also get
## the classical result as binary vectors, not integers.
coded = zeros(4,2);
coded(1,:) = simulate(ZrZr,0,"samples",1,"classicalout","Bin");
coded(2,:) = simulate(ZrOn,0,"samples",1,"classicalout","Bin");
coded(3,:) = simulate(OnZr,0,"samples",1,"classicalout","Bin");
coded(4,:) = simulate(OnOn,0,"samples",1,"classicalout","Bin");

## lets take a look at the result and verify it as well
coded
assert(isequal(coded,[0,0;0,1;1,0;1,1]));
