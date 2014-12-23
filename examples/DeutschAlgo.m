1;

## load the oct-circuits package
pkg load qcs;

## First some circuit descriptors. Logical sub-circuits are grouped such that
##  each circuit follows the prep,oracle,measure pattern

## build circuits for each of the 4 functions

## basic circuits with no nesting
## putting the empty circuit QIR in front causes the subcircuits to
## properly nest.  In this case we're nesting the Bell-Basis measurement
## at the end and, when needed, the oracle circuit
id_cir =  [QIR,QIR("H",0:1),QIR("CNot",0,1),[QIR("H",1),QIR("Measure",1)]];
one_cir = [QIR,QIR("H",0:1),QIR("X",1),[QIR("H",1),QIR("Measure",1)]];
zero_cir = [QIR,QIR("H",0:1),QIR("I",1),[QIR("H",1),QIR("Measure",1)]];
not_cir = [QIR,QIR("H",0:1), ...
           [QIR("X",1),QIR("CNot",0,1), QIR("X",1)], ...
					 [QIR("H",1),QIR("Measure",1)]];


## Let's start with id_cir and some basic simulation.
##  Notice that circuits carry a lot of data about their structure
##  bits targeted/used by gates, number of bits, and steps per depth
##  at each depth
display(id_cir);

## by default the simulation will run to completion w.r.t to depth 1
## let's simulate id_cir on an input of 1
res = simulate(id_cir,1)

## Like many quantum algoriths, Deutsch's Algorithm uses work bits
## whose ultimate value we don't care about. More specifically, we'd
## like to know the final value of the high order bit only.  A standard way
## of extracting this information is by using the partial trace to
## trace out the low order bit. Partial traces work on density operators

## first get the density operator of res
resOp = pureToDensity(res);
## now trace out the space of bit 0. We should see |1><1|
resOp = pTrace(0,resOp)
## let's just double check that they're more or less the same
## via the operator norm based operr
assert(operr(resOp,[0,0; 0,1]) < 2^-30);

## Let's look at const_one, a constant function.

## This time we'll pass a binary row-vector as the input.
res = simulate(one_cir,[0,1])
##  Because this is a constant function, we should get |0><0| as the result.
resOp = pTrace(0,pureToDensity(res))
assert(operr(resOp,[1,0; 0,0]) < 2^-30);

## You can also pass in basis vectors as initial inputs
res = simulate(one_cir,stdBasis(1,2));
resOp = pTrace(0,pureToDensity(res))
assert(operr(resOp,[1,0; 0,0]) < 2^-30);

## simulate allows you to dictate depth and steps carried out by the
## simulation. This allows you trace through the circuit gate-by-gate
## or even logical step-by-step.

## let's step through bal_not at depth 1 and save each intermediate
## result. At this depth gates are grouped logically: inital state
## prep, oracle, final 'decode' and measurement.
res = zeros(4,stepsAt(not_cir,1)+1);
for k = 1:length(res)
  res(:,k) = simulate(not_cir,1,1,k-1);
endfor
res

## Then perhaps we'd like to observe the change only on the key bit, bit 1,
## using density operators
resOp = zeros(2,2,length(res));
for k = 1:length(resOp)
  resOp(:,:,k) = pTrace(0,pureToDensity(res(:,k)));
endfor
resOp

## Now let's get a more fine grained picture by stepping through depth
## 2.  In this case, this gives us a gate by gate picture of what's
## happening.
res = zeros(4,stepsAt(not_cir,2)+1);
for k = 1:length(res)
  res(:,k) = simulate(not_cir,1,2,k-1);
endfor
res

## And the density matrix for Qubit #1...
resOp = zeros(2,2,length(res));
for k = 1:length(resOp)
  resOp(:,:,k) = pTrace(0,pureToDensity(res(:,k)));
endfor
resOp


## We might check this statistically. This is a deterministic
##  algorithm, so we expect the right results 100% time.  Let's see what we see...

## we'll sum the resultant density matricies
bid = zeros(2,2);
bnot = zeros(2,2);
cone = zeros(2,2);
czero = zeros(2,2);

## over the course of 100 circuit executions
for k = [1:100]
  bid = bid + pTrace(0,pureToDensity(simulate(id_cir,1)));
  bnot = bnot + pTrace(0,pureToDensity(simulate(not_cir,1)));
  cone = cone + pTrace(0,pureToDensity(simulate(one_cir,1)));
  czero = czero + pTrace(0,pureToDensity(simulate(zero_cir,1)));
endfor

## and report the sample mean.
assert(operr(bid/100,[0,0 ; 0,1]) < 2^-30)
assert(operr(bnot/100,[0,0 ; 0,1]) < 2^-30)
assert(operr(cone/100,[1,0 ; 0,0]) < 2^-30)
assert(operr(czero/100,[1,0 ; 0,0]) < 2^-30)
