# Quantum Circuit Sandbox (qcs)

Quantum Circuit Sandbox (qcs) is a free, open-source [GNU Octave](https://www.gnu.org/software/octave/)<sup>1</sup> package that enables the construction, simulation, and synthesis of basic quantum circuits in an embedded, domain specific language fashion with Octave as the host language.

## Installation

The qcs package is a proper GNU Octave package and is easily [installed](https://www.gnu.org/software/octave/doc/interpreter/Installing-and-Removing-Packages.html) using the Octave `pkg` commands. Just download the gzipped compressed tar of the latest release
and Octave will do the rest.

```
pkg install qcs-1.4.3.tar.gz
```

Parts of qcs can make use of the Parallel package if you have it installed
as well.  To install parallel from [Octave-Forge](http://octave.sourceforge.net/) do the following:

```
pkg install -forge parallel
```

To load the packages you simply type the following at the Octave prompt:

```
pkg load qcs
pkg load parallel
```

## Getting Started

The Examples directory of the qcs repository contains three script files that
illustrate the most basic usage patterns in qcs by simulating and analyzing
Deutsch's Algorithm, super-dense coding, and teleportation.


The file DeutschAlgo.m looks at everyone's favorite first quantum algorithm, Deutsch's Algorithm<sup>2</sup>.  Here are a few key parts of qcs taken from that file.

#### Constructing Circuits

Circuits, like the `not_cir` circuit that runs Deutsch's algorithm
with an Oracle for the not function, are built like Octave vectors/matricies
using the `QIR` gate constructor function to specify individual gates.

```
not_cir = [QIR,...
           QIR("H",0:1), ...
           [QIR("X",1),QIR("CNot",0,1), QIR("X",1)], ...
					 [QIR("H",1),QIR("Measure",1)]];
```

Circuits can be nested to capture the logical structure of the circuit. The `QIR` at the start of `not_cir' ensures proper nesting. In `not_cir` you see the initial Hadamard gate application to both qubits, the Oracle circuit,and finally the measurement. For the complete documentation of `QIR` run `help QIR` at the Octave prompt.

#### Simulating Circuits

The `simulate` function is used to simulate a circuit. Its options provide fine grained control of the simulator and its output. For all the details run `help simulate` at the Octave prompt.

Basic simulations run a circuit with an input.
```
simulate(not_cir,1)
```
The input can be an integer, a row vector of 0 and 1 representing a binary
number, or one of the standard basis vectors for the circuit. Basic simulations
result in an n-qubit basis state expressed as an Octave column vector.

Like many quantum algorithms, Deutsch's algorithm utilizes some work space in the low order bits. Simulate lets you specify the size that workspace. When you do, the simulation will perform a partial trace of the state and give you the density matrix for the non-work space.

```
simulate(not_cir,1,"worksize",1);
```

If you'd prefer to get classical output, then you can instruct `simulate` to sample the final state of the simulation. This option also allows for multiple samples. In which case, the majority result is reported. Combining this with the worksize option lets you get the classical value of only the non-work bits.

```
simulate(not_cir,1,"worksize",1,"sample",1);
```

#### Synthesis and Compilation

The acronym QIR is short for Quantum Intermediate Representation and comes from the work of Svore, et. al.<sup>3</sup>. The `qcc` function (short for Quantum Circuit Compiler) can be used to reduce QIR based circuits to elementary circuits that use only the two qubit Controlled-Not gate and single qubit operators. Running `help qcc` provides complete documentation.

The first target of `qcc` is a Quantum Intermediate Assembly (QIASM) circuit. These circuits utilize arbitrary single qubit unitary matricies and C-Not. These circuits are equivalent to the QIR from which they are compiled.

The second target of qcc is a Quantum Assembly (QASM) circuit. A QASM circuit is an approximation of the QIR circuit that uses a finite set of single qubit unitary matricies. An implementation of the Solovay-Kiteav algorithm<sup>4</sup> is used to perform the QIASM to QASM compilation do arbitrary precision. In its current state, compiling to QASM is very slow but can be sped up a bit by loading the parallel package. User be warned.

##### References

[1] John W. Eaton, David Bateman, Søren Hauberg, Rik Wehbring (2015).
    GNU Octave version 4.0.0 manual: a high-level interactive language for
    numerical computations.
    URL http://www.gnu.org/software/octave/doc/interpreter/

[2]  David Deutsch (1985). "Quantum Theory, the Church-Turing Principle and the Universal Quantum Computer" (PDF). Proceedings of the Royal Society of London A 400: 97. Bibcode:1985RSPSA.400...97D. doi:10.1098/rspa.1985.0070

[3] Krysta M. Svore, Alfred V. Aho, Andrew W. Cross, Isaac Chuang, and Igor L. Markov. 2006. A Layered Software Architecture for Quantum Computing Design Tools. Computer 39, 1 (January 2006), 74-83. DOI=http://dx.doi.org/10.1109/MC.2006.4

[4] Christopher M. Dawson and Michael A. Nielsen. 2006. The Solovay-Kitaev algorithm. Quantum Info. Comput. 6, 1 (January 2006), 81-95.
