## Copyright (C) 2014  James Logan Mayfield
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.


## -*- texinfo -*-
## @deftypefn {Function File} {@var{s} =} simulate (@var{cir},@var{in})
## @deftypefnx {Function File} {@var{s} =} simulate (@var{cir},@var{in},@var{OPT-KEY},@var{OPT-VAL},...)
##
## Simulate the action of circuit @var{cir} on input @var{in}.
##
## For a circuit @var{cir} on @math{n} qubits, the input @var{in} can be any natural number from @math{[0,2^n)}, a @math{n} bit binary number as a @math{n} row vector with length at most @math{n}, or an @math{n} qubit standard basis vector.
##
## The following optional arguments are passed as @var{OPT-KEY}-@var{OPT-VAL} pairs. They can be passed in any order.
##
## @b{``depth''}
## @quotation
## The ``depth'' option takes on as its value any positive integer. Simulations at depth @math{d} treat nested sub-circuits at a depth greater than or equal to @math{d} as atomic steps. This option is typically combined with the @b{``steps''} option to control how much of the circuit is simulated. The default depth value for simulation is @math{1}.
## @end quotation
##
## @b{``steps''}
## @quotation
## The ``steps'' option takes on as its value any postive integer that is less than or equal to the circuit steps at the current simulation depth. Given a steps value of s, a simulation will run for exactly @math{s} steps with respect to the simulation depth. By default, the entire circuit is simulated and the steps value is the number of steps for the specified simulation depth.
## @end quotation
##
## @b{``samples''}
## @quotation
## The ``samples'' option takes on as its value any positive integer. A simulation performed with a ``samples'' value of @math{s>1} will be repeated @math{s} times and at the end of each computation a measurement in the standard basis is performed. The majority result of those @math{s} samples is then returned as the result of the simulation. By default, no samples are taken and the output of the simulation is the output of the circuit.
## @end quotation
##
## @b{``worklocation''}
## @quotation
## The ``worklocation'' option is either ``Lower'' or ``Upper'' and determines if the lower order qubits or upper order qubits are the work space of the circuit. When combined with the ``worksize'' option, this can induce a partial trace of the workspace after simulation. The default work space location is ``Lower''.
## @end quotation
##
## @b{``worksize''}
## @quotation
## The ``worksize'' option takes on as its value any postive integer or zero.  When the worksize @math{w>0} is given the simulation will automatically do a partial trace over the work space as indicated by the ``worklocation'' option. As a result, the density matrix for the non-work qubits is returned as the simulation result. By default, the work space size is 0 and no partial trace is performed. If this option is combined with samples, then the measurement is take with respect to the traced-out state and the result is that of the non-work space and not the complete circuit space.
## @end quotation
##
## @b{``classicalout''}
## @quotation
## The ``classicalout'' option is either ``Int'' or ``Bin''. When simulation is done with classical output and at least one sample measurement is taken, then the simulation result will be returned as classical output. The ``Int'' option value returns the integer index of the standard basis and the ``Bin'' option returns that same value as a binary column vector. If no samples are requested, then this option has no effect.
## @end quotation
##
## @seealso{measure,binaryRep,stdBasis,pTrace}
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Simulation

function s = simulate(cir,in,varargin)

  ## check and convert input
  s0 = processIn(in,get(cir,"bits"));


  ## get/init optionals/initialize
  [r,d,t,samps,wsize,wloc,clasOut] = ...
     parseparams(varargin,"depth",1, ...
                          "steps",-1, ...
                          "samples",0, ...
                          "worksize",0, ...
                          "worklocation","Lower", ...
                          "classicalout","Int");

  ## error check optionals
  if( d < 1 || floor(d)!=ceil(d) )
    error("simulate: Depth must be a Zero or a positive integer.");
  endif

  if( t == -1 )
    ## default initialization
    t=get(cir,"stepsAt")(d);
  elseif(!isNat(t))
    error("simulate: Number of time steps must be zero or a \
    positive integer.");
  endif

  if( !strcmp(wloc,"Lower") && !strcmp(wloc,"Upper") )
    error("simulate: Bad workspace location. %s", wloc);
  endif

  if( !isNat(wsize) || wsize > get(cir,"bits") )
    error("simulate: Bad workspace size. %f",wsize);
  endif

  if( !strcmp(clasOut,"Int") && !strcmp(clasOut,"Bin"))
    error("simulate: Bad classical output type. %s",clasOut);
  endif

  ## Ok. Optionals should be good. We're ready to roll...

  ## simulate
  if( t == 0 )
    s = s0;
  else
    s = sim(cir,s0,d,t);
  endif
  s = full(s);

  ## post-process based on optionals

  ## Trace out work if needed
  if( wsize > 0 )
    if( strcmp(wloc,"Lower") )
      spc = 0:(wsize-1);
    else ## it's "Upper"
      n = get(cir,"bits");
      spc = (n-wsize):(n-1);
    endif
    s = pTrace(spc,pureToDensity(s));
  endif

  ## sample if needed
  if( samps > 0 )
    s = measure(s,"samples",samps,"binary",strcmp("Bin",clasOut));
  endif


endfunction

## check and converting circuit input
function s = processIn(in,n)

  s = stdBasis(0,n);

  if( !isvector(in) )
    error("simulate: Second argument must be a natural number, pure state \
vector, or a bit vector.");
  elseif( isscalar(in) )
    if( in < 0  || floor(in) != ceil(in) || in >= 2^n )
      error("simulate: Scalar input must be a natural number in \
[0,|cir|)");
    else
      s = stdBasis(in,n);
    endif
  elseif( length(in) == n && isBitArray(in) )
    s = stdBasis(in,n);
  elseif( length(in) == 2^n && sum(in==0) == (2^n-1) && sum(in==1) == 1)
    s = in;
  else
    error("simulate: circuit input must be a state vector or bit \
vector. Got some other vector.");
  endif

endfunction

%!test
%! C = @QASMcircuit(@QASMseq({@QASMsingle("Z",0)}));
%!error simulate(C,zeros(2,2)); #no matrix
%!error simulate(C,{0,1,0}); #no arrays
%!error simulate(C,-1); #no negatives
%!error simulate(C,pi); #no reals
%!error simulate(C,2); #bounds check on circuit
%!error simulate(C,1:3); #bad vector
%!error simulate(C,(1:3)'); #bad vector again
%! assert(simulate(C,(0:1)'==0),simulate(C,[0]));
%! assert(simulate(C,(0:1)'==0),simulate(C,0));
%! assert(simulate(C,(0:1)'==1),simulate(C,[1]));
%! assert(simulate(C,(0:1)'==1),simulate(C,1));

%!test
%! ##A Deutsch Algorithm circuit... balanced function (not)
%! not_cir = [QIR,QIR("H",0:1), ...
%!            [QIR("X",1),QIR("CNot",0,1), QIR("X",1)], ...
%!            [QIR("H",1),QIR("Measure",1)]];
%! a = simulate(not_cir,1,"steps",2);
%! b = simulate([QIR("H",0:1),QIR("X",1),QIR("CNot",0,1), QIR("X",1)],1);
%! assert(abs(a - b) < 2^-30);
%! a = simulate(not_cir,1,"steps",3,"depth",2);
%! b = simulate([QIR("H",0:1),QIR("X",1),QIR("CNot",0,1)],1);
%! assert(abs(a - b) < 2^-30);
%! a = simulate(not_cir,1,"WorkSize",1);
%! assert(abs(a-[0,0;0,1]) < 2^-30);
%! a = simulate(not_cir,1,"WorkLocation","Upper","WorkSize",1);
%! b = 1/2 * [1,-1;-1,1];
%! assert(abs(a - b) < 2^-30);
%! a = simulate(not_cir,1,"samples",75);
%! assert(a == 2 || a == 3);
%! a = simulate(not_cir,1,"samples",75,"ClassicalOut","Bin");
%! assert(isequal(a,[1,0]) || isequal(a,[1,1]));
%! a = simulate(not_cir,1,"samples",75,"WorkSize",1);
%! assert(a,1);
