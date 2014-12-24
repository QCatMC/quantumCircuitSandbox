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

## Usage: s = simulate(cir,in,d,t)
##
## Simulate t steps, w.r.t. nesting depth d, of the circuit object cir on
## input in.
##
## The input argument in can be a standard basis vector, a binary row
## vector, or a natural number.
##
## When the desired number of time steps t is not given, then the
## entire circuit will be simulated and the depth value d is optional.
## Thus, simulate(cir,in) will carry out a simulation of the entire
## circuit.

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
