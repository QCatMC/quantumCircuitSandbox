1;

## load the oct-circuits package
pkg load oct-circuits;

## First some circuit descriptors. Logical sub-circuits are grouped such that
##  each circuit follows the prep,oracle,measure pattern

## Balanced Functions
bal_id = {{{"H",0},{"H",1}},{"CNot",0,1},{"H",1},{"Measure",1}};
bal_not = {{{"H",0},{"H",1}},{{"X",1},{"CNot",0,1},{"X",1}}, ...
	   {"H",1},{"Measure",1}};

## Constant Functions
const_one = {{{"H",0},{"H",1}},{"X",0},{"H",1},{"Measure",1}};
const_zero = {{{"H",0},{"H",1}},{"H",1},{"Measure",1}};

## Use buildCircuit to construct proper circuit data
id_cir = buildCircuit(bal_id);
not_cir = buildCircuit(bal_not);
one_cir = buildCircuit(const_one);
zero_cir = buildCircuit(const_zero);

## Let's start with id_cir and some basic simulation.
##  Notice that circuits carry a lot of data about their structure
##  bits targeted/used by gates, number of bits, and steps per depth
##  at each depth
id_cir

## by default the simulation will run to completion w.r.t to depth 1
res = simulate(id_cir,1)

## Like many quantum algoriths, Deutsch's Algorithm uses work bits
## whose ultimate value we don't care about. More specifically, we'd 
## like to know the final value of the high order bit.  A standard way
## of extracting this information is by using the partial trace to
## trace out the low order bit. 

## get the density operator of res
resOp = pureToDensity(res);
## now trace out the space of bit 0. We should see |1><1|
pTrace(0,resOp)

## Let's look at const_one, a constant function. 

## This time we'll pass a binary row-vector as the input.
res = simulate(one_cir,[0,1])
##  Because this is a constant function, we should get |0><0| as the result.
pTrace(0,pureToDensity(res))

## You can also pass in basis vectors as initial inputs
res = simulate(one_cir,stdBasis(1,2));
pTrace(0,pureToDensity(res))

## simulate allows you to dictate depth and steps carried out by the
## simulation. This allows you trace through the circuit gate-by-gate
## or even logical step-by-step. 

## let's step through bal_not at depth 1 and save each intermediate
## result. At this depth gates are grouped logically: inital state
## prep, oracle, final 'decode', then measurement. 
res = zeros(4,stepsAt(not_cir,1)+1);
for k = 1:length(res)
  res(:,k) = simulate(not_cir,1,1,k-1);
endfor
res

## Then perhaps we'd like to observe the change only on the key bit, bit 1, using 
## density operators
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


## Of course we should really check this statistically. This is a deterministic
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
bid/100
bnot/100
cone/100
czero/100
