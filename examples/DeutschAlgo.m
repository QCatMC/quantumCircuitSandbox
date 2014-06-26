1;

## load the oct-circuits package
pkg load oct-circuits;

## Balanced Function Circuits
bal_id = {{"H",0},{"H",1},{"CNot",0,1},{"H",1},{"Measure"}};
bal_not = {{"H",0},{"H",1},{"X",1},{"CNot",0,1},{"X",1},{"H",1},{"Measure"}};

## Constant Functions
const_one = {{"H",0},{"H",1},{"X",0},{"H",1},{"Measure"}};
const_zero = {{"H",0},{"H",1},{"H",1},{"Measure"}};


# Let's start with bal_id. The oracle here is the CNot operator which computes
#  the ID function in a reversible setting

## To run the whole circuit we just pass the input, circuit, and number of 
##  qubits. In this case, the input is given as a positive integer which 
##  is converted to the appropriate basis state.
res = evalCircuit(1,bal_id,2);

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


##  We can also evaluate a circuit from t=0 to t = b < |cir|.  Let's "step" through bal_not
##  and push each intermidiate result to a matrix column for easy viewing/reference
res = zeros(4,length(bal_not));
for k = [0:length(bal_not)]
  res(:,k+1) = evalCircuit(1,bal_not,2,k);
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
  res(:,k+1) = evalCircuit(1,const_zero,2,k);
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
