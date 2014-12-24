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
##  just run these on single qubit circuits
st1 = simulate(a1(0),1);
s2 = simulate(a2(0),1);
## then view the density matrix because that's what we'll
## see after tracing out part of the teleportation circuit
st1 = pureToDensity(s1);
st2 = pureToDensity(s2);

## time to teleport.

## first the complete circuits
circ1 = [QIR,a1(2),Tele];
circ2 = [QIR,a2(2),Tele];

in = pTrace(1:2,stdBasis(4,3)) # the input

## now run and trace out all but bit 0 (the result). again, we tag
## the upper portion as work space here so that the simulator will
## trace bits 2 and 1 out, leaving only the state of 0 as the result
c1Out = simulate(circ1,4,"worklocation","Upper","worksize",2)
c2Out = simulate(circ2,4,"worklocation","Upper","worksize",2)

## check against expected results
assert(operr(c1Out,st1) < 2^-40)
assert(operr(c2Out,st2) < 2^-40)
