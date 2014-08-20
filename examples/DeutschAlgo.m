1;

## load the oct-circuits package
pkg load oct-circuits;

## Circuit Descriptors. Logical sub-circuits are grouped such that
##  each circuit follows the prep,oracle,measure pattern

## Balanced Function Circuits
bal_id = {{{"H",0},{"H",1}},{"CNot",0,1},{"H",1},{"Measure",1}};
bal_not = {{{"H",0},{"H",1}},{{"X",1},{"CNot",0,1},{"X",1}}, ...
	   {"H",1},{"Measure",1}};

## Constant Functions
const_one = {{{"H",0},{"H",1}},{"X",0},{"H",1},{"Measure",1}};
const_zero = {{{"H",0},{"H",1}},{"H",1},{"Measure",1}};

## Construct the circuit objects.
id_cir = buildCircuit(bal_id);
not_cir = buildCircuit(bal_not);
one_cir = buildCircuit(const_one);
zero_cir = buildCircuit(const_zero);

## Let's start with id_cir and some basic simulation.

## by default the simulation will run to completion
res = simulate(1,id_cir)

## Like many quantum algorithms, we're only interested in the value of some of the bits.
## However, oct-Circuits 0.0.2 only does complete measurements. It's easy to figure out 
## the state of bit 1 with Deutsch's algorithm, but a good general purpose way of looking
## at the state of some of the system is using partial traces of the density operators.

## get the density operator of res
resOp = pureToDensity(res);
## now trace out the space of bit 0. We should see |1><1|
pTrace(0,resOp)

## Let's look at const_one, a constant function. 

## This time we'll pass a binary row-vector as the input.
res = evalCircuit([0,1],const_one,2);
##  Because this is a constant function, we should get |0><0| as the result.
pTrace(0,pureToDensity(res))

## Maybe the standard basis?
res = evalCircuit(stdBasis(1,2),const_one,2);
pTrace(0,pureToDensity(res))

##  We can also evaluate part of the circuit.  Let's "step" through bal_not
##  and push each intermidiate result to a matrix column for easy viewing/reference
res = zeros(4,length(bal_not));
for k = [0:length(bal_not)]
  res(:,k+1) = evalCircuit(1,bal_not,2,1:k);
endfor
res

## Then perhaps we'd like to observe the change only on the key bit, bit 1, using 
## density operators
resOp = zeros(2,2,length(res));
for k = [1:length(res)]
  resOp(:,:,k) = pTrace(0,pureToDensity(res(:,k)));
endfor
resOp


## One last time with const_zero
res = zeros(4,length(const_zero));
for k = [0:length(const_zero)]
  res(:,k+1) = evalCircuit(1,const_zero,2,1:k);
endfor
res

resOp = zeros(2,2,length(res));
for k = [1:length(res)]
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
  bid = bid + pTrace(0,pureToDensity(evalCircuit(1,bal_id,2)));
  bnot = bnot + pTrace(0,pureToDensity(evalCircuit(1,bal_not,2)));
  cone = cone + pTrace(0,pureToDensity(evalCircuit(1,const_one,2)));
  czero = czero + pTrace(0,pureToDensity(evalCircuit(1,const_zero,2)));
endfor

## and report the sample mean.
bid/100
bnot/100
cone/100
czero/100
