1;

pkg load oct-circuits;

## Quantum Teleportation 

## Std->Bell Basis Prep on [0,1]
bP = {{"H",1},{"CNot",0,1}};

## Bell Measurement on [2,1]
bM = {{"CNot",1,2},{"H",2},{"Measure",[2,1]}};

## Cntrl-Z with control on 2 and target on 0
cZ = {{"H",0},{"CNot",0,2},{"H",0}};


## The teleportation circuit. Just prep bit 2 with the 
## state to be teleported.
Tele = {bP{:},bM{:},{"CNot",0,1},cZ{:}};

## Some circuits to prep. Alice's state
a1 = @(t) {{"T",t},{"S",t}};
a2 = @(t) {{"H",t},{"Y",t}};

## let's be sure we know what state we're teleporting. 
s1 = simulate(buildCircuit(a1(0)),1);
pureToDensity(s1)
s2 = simulate(buildCircuit(a2(0)),1);
pureToDensity(s2)

## time to teleport.

## first the complete circuits
circ1 = {a1(2){:},Tele{:}};
circ2 = {a2(2){:},Tele{:}};

in = pTrace(1:2,pureToDensity(stdBasis(4,3))) # the input

## now run and trace out all but bit 0 (the result)
c1Out = pTrace(1:2,pureToDensity(simulate(buildCircuit(circ1),4)))
c2Out = pTrace(1:2,pureToDensity(simulate(buildCircuit(circ2),4)))
