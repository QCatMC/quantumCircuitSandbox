1;

pkg load qcs;

## Quantum Teleportation

## Std->Bell Basis Prep on [0,1]
bP = [QIR("H",1),QIR("CNot",0,1)];

## Bell Measurement on [2,1]
bM = [QIR("CNot",1,2),QIR("H",2),QIR("Measure",[2,1])];

## Cntrl-Z with control on 2 and target on 0
cZ = [QIR("H",0),QIR("CNot",0,2),QIR("H",0)];

## The teleportation circuit. Just prep bit 2 with the
## state to be teleported.
Tele = [QIR,bP,bM,QIR("CNot",0,1),cZ];

## Some circuits to prep. Alice's state
a1 = @(t) [QIR("T",t),QIR("S",t)];
a2 = @(t) [QIR("H",t),QIR("Y",t)];

## let's be sure we know what state we're teleporting.
s1 = simulate(a1(0),1);
st1 = pureToDensity(s1)
s2 = simulate(a2(0),1);
st2 = pureToDensity(s2)

## time to teleport.

## first the complete circuits
circ1 = [QIR,a1(2),Tele];
circ2 = [QIR,a2(2),Tele];

in = pTrace(1:2,pureToDensity(stdBasis(4,3))) # the input

## now run and trace out all but bit 0 (the result)
c1Out = pTrace(1:2,pureToDensity(simulate(circ1,4)))
c2Out = pTrace(1:2,pureToDensity(simulate(circ2,4)))

## check against expected results
assert(operr(c1Out,st1) < 2^-40)
assert(operr(c2Out,st2) < 2^-40)
