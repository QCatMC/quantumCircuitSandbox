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
resOp = puretodensity(res);
## now trace out the space of bit 0. We should see |1><1|
resOp = ptrace(0,resOp);
## We can also just trace the vector directly and get the same
## result. pTrace just does the vector->matrix conversion for us
resOp = ptrace(0,res);
## let's just double check that they're more or less the same
## via the operator norm based operr
assert(operr(resOp,[0,0;0,1]) < 2^-30);

## If density matrices aren't your thing, then we can then do a complete
## measurement of the density operator to get the integer value of the result.
resInt = measure(resOp);
assert(resInt,1);


## This post processing task is common enough that you can get the
## simulator to do it for you.
resInt = simulate(id_cir,1,"worksize",1,"samples",1);
assert(resInt,1);
## By default the work space is the lower order qubits. WorkSize
## dictates the size and the simulator will trace out that space
## for you. The samples option then directs the simulator to measure
## the result and return the classical result.

## Let's look at one_cir, the circuit for the constant function that
## computes 1.

## This time we'll pass a binary row-vector as the input.
res = simulate(one_cir,[0,1],"worksize",1,"samples",1);
##  Because this is a constant function, we should get 0 as the result
assert(res,0);

## You can also pass in basis vectors as initial inputs
res = simulate(one_cir,stdbasis(1,2),"worksize",1,"samples",1);
assert(res,0);

## simulate also allows you to dictate depth and steps carried out by the
## simulation. This allows you trace through the circuit gate-by-gate
## or even logical step-by-step.

## let's step through bal_not at depth 1 and save each intermediate
## result. At this depth gates are grouped logically: inital state
## prep, oracle, final 'decode' and measurement. Let's look at the
## quantum state result to get the complete picture.
res = zeros(4,stepsat(not_cir,1)+1);
for k = 1:length(res)
  res(:,k) = simulate(not_cir,1,"ndepth",1,"steps",k-1);
endfor
## now we can see the quantum state at each logical step
display(res)

## Then perhaps we'd like to observe the change only on the key bit, bit 1,
## using density operators
resOp = zeros(2,2,length(res));
for k = 1:length(resOp)
  resOp(:,:,k) = ptrace(0,res(:,k));
endfor
display(resOp)

## Now let's get a more fine grained picture by stepping through depth
## 2.  For this circuit, this gives us a gate by gate picture of what's
## happening.  Let's skip right to the density matrix for the work space
res = zeros(2,2,stepsat(not_cir,2)+1);
for k = 1:length(res)
  res(:,:,k) = simulate(not_cir,1,"ndepth",2,"steps",k-1,"worksize",1);
endfor
display(res)

## Maybe you'd like to see what's happening in the work space. We can
## trick the simulator into thinking the data space is the work space
## by setting worklocation to "Upper".
reswork = zeros(2,2,stepsat(not_cir,2)+1);
for k = 1:length(resOp)
  resOp(:,:,k) = simulate(not_cir,1,"ndepth",2,"steps",k-1,...
                          "worksize",1,"worklocation","Upper");
endfor
display(resOp)

## Deutsch's Algorithm is deterministic, but if it weren't we might
## want to repeat the computation some number of times, measure each
## result and take the majority result as 'the' result of the algorithm.
## In practice, we'd recompute.  In qcs, we can take multiple measurements
## without re-simulating, or "repeating the experiment".

## Here we simulate each circuit, trace out the work space, and sample
## the results 50 times, and returns the majority answer.
## The result is the integer value of the basis of the majority result
## in the non-work subspace of the circuit, i.e. the answer you'd be
## looking for if you ran this algorithm in practice.
notRes = simulate(not_cir,1,"samples",50,"worksize",1);
idRes = simulate(id_cir,1,"samples",50,"worksize",1);
oneRes = simulate(one_cir,1,"samples",50,"worksize",1);
zeroRes = simulate(zero_cir,1,"samples",50,"worksize",1);

## and the expected results..
assert(notRes,1);
assert(idRes,1);
assert(oneRes,0);
assert(zeroRes,0);
