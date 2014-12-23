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
resOp = pTrace(0,resOp);
## If density matrices aren't your thing, then we can then do a complete
## measurement of the density operator to get the integer value of the result.
resInt = measure(resOp);
## let's just double check that they're more or less the same
## via the operator norm based operr
assert(resInt,1);

## Let's look at const_one, a constant function.

## This time we'll pass a binary row-vector as the input.
res = simulate(one_cir,[0,1]);
##  Because this is a constant function, we should get |0><0| as the result.
resOp = pTrace(0,pureToDensity(res));
resInt = measure(resOp);
assert(resInt,0);

## You can also pass in basis vectors as initial inputs
res = simulate(one_cir,stdBasis(1,2));
resOp = pTrace(0,pureToDensity(res));
assert(measure(resOp),0);

## simulate allows you to dictate depth and steps carried out by the
## simulation. This allows you trace through the circuit gate-by-gate
## or even logical step-by-step.

## let's step through bal_not at depth 1 and save each intermediate
## result. At this depth gates are grouped logically: inital state
## prep, oracle, final 'decode' and measurement.
res = zeros(4,stepsAt(not_cir,1)+1);
for k = 1:length(res)
  res(:,k) = simulate(not_cir,1,"depth",1,"steps",k-1);
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
  res(:,k) = simulate(not_cir,1,"depth",2,"steps",k-1);
endfor
res

## And the density matrix for Qubit #1...
resOp = zeros(2,2,length(res));
for k = 1:length(resOp)
  resOp(:,:,k) = pTrace(0,pureToDensity(res(:,k)));
endfor
resOp

## Deutsch's Algorithm is deterministic, but if it weren't we might
## want to repeat the computation some number of times, measure each
## result and take the majority result as 'the' result of the algorithm.
## In practice, we'd recompute.  In qcs, we can take multiple measurements
## without re-simulating, or "repeating the experiment".

## let's resimulate each circuit and save the resultant states
notRes = pTrace(0,pureToDensity(simulate(not_cir,1)));
idRes = pTrace(0,pureToDensity(simulate(id_cir,1)));
oneRes = pTrace(0,pureToDensity(simulate(one_cir,1)));
zeroRes = pTrace(0,pureToDensity(simulate(zero_cir,1)));

## now we can measure that state and take multiple samples.
## let's just do 50 samples.
assert(measure(notRes,"samples",50),1);
assert(measure(idRes,"samples",50),1);
assert(measure(oneRes,"samples",50),0);
assert(measure(zeroRes,"samples",50),0);
