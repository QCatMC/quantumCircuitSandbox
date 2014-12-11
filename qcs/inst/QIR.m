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

## usage: C = QIR(...)
##
## Factor method for construting QIR gate objects
##
##

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIR

function C = QIR(name,varargin)
  if( nargin == 0 )
    C = @QIRcircuit();
    return;
  endif

  switch(name)
    case "Toffoli"
       [t,c] = parseTof(varargin);
       C = @QIRtoffoli(t,c);
    case "Fredkin"
       [t,c] = parseFred(varargin);
       C = @QIRfredkin(t,c);
    case "Swap"
       [t1,t2] = parseSwap(varargin);
       C = @QIRswap(t1,t2);
    case "Measure"
       t = parseMeasure(varargin);
       C = @QIRmeasure(t);
    case "CU"
       [o,t,c] = parseCU(varargin);
       C = @QIRcU(t,c,o);
    case "CNot"
       [t,c] = parseCNot(varargin);
       C = @QIRcU(t,c,{"X"});
    case {"PhAmp","Rn","ZYZ"}
       [t,p] = parseQIASM(name,varargin);
       C = @QIRsingle(name,t,p);
    case {"I","X","Y","Z","S","T", "H"...
          "I'","X'","Y'","Z'","S'","T'","H'"}
       t = parseQASM(name,varargin);
       C = @QIRsingle(name,t,[]);
    otherwise
       error('QIR: Unknown operator %s',name);
  endswitch

endfunction

function [t,c] = parseCNot(args)
  if( length(args) != 2)
    error("CNot: requires 2 arguments, given %d",length(args));
  endif

  t = args{1};
  c = args{2};

  if( !isscalar(t) && !isNat(t) )
    error("CNot: Bad target");
  elseif( !isscalar(c) && !isNat(c) )
    error("CNot: Bad control");
  elseif( t == c)
    error("CNot: Target and control cannot be the same");
  endif

endfunction

function t = parseQASM(name,args)
  if( length(args) != 1 )
    error("%s: Expected one argument given %d",name,length(args));
  endif

  t = args{1};

  if(!isNat(t))
    error("%s: Bad Target");
  endif

endfunction

function [t,p] = parseQIASM(name,args)
  if( length(args) != 2 )
    error("%s: Expects 2 arguments, given %d",name,length(args));
  endif

  t = args{2};
  p = args{1};

  switch(name)
    case {"PhAmp","ZYZ"}
      if( !isreal(p) && !isequal(size(p),[1,3]) && !isequal(size(p),[1,4]) )
        error("%s: Bad parameters. Must be real and either 3 or 4 parameters");
      endif
    case "Rn"
      if( !isreal(p) && !isequal(size(p),[1,4]) && !isequal(size(p),[1,5])  )
        error("%s: Bad parameters. Must be real and either 3 or 4 parameters");
      elseif( (1 - p(2:4)*(p(2:4))') > 2^(-40) )
        error("Rn: n must be a unit vector");
      endif
  endswitch

  if( !isscalar(t) && !isNat(t) )
    error("%s: Bad target",name);
  endif

endfunction

function [t,c] = parseTof(args)

    if( length(args) != 2 )
      error("Toffoli: requires 2 arguments, given %d",length(args));
    endif

    ##  get targets and control
    t = args{1};
    c = args{2};

    ## control check
    if( !isequal(size(c),[1,2]) || !isNat(c) || c(1) == c(2) )
      error("Toffoli: Given bad controls");
    ## target check
    elseif( !isscalar(t) || !isNat(t) || !isequal([0,0],t==c ) )
      error("Toffoli: Given bad target");
    endif
    c = sort(c,"descend");

endfunction

function [t,c] = parseFred(args)

  ## desc length check
  if( length(args) != 2 )
    error("Fredkin:  Expects 2 arguments given %d.",length(args));
  endif

  t = args{1};
  c = args{2};

  ## control check
  if( !isequal(size(t),[1,2]) || !isNat(t) || t(1) == t(2) )
    error("Fredkin: given bad targets");
    ## target check
  elseif( !isscalar(c) || !isNat(c) || !isequal([0,0],c==t) )
    error("Fredkin: given bad control");
  endif

  t  = sort(t,"descend");

endfunction

function [t1,t2] = parseSwap(args)
  if( length(args) != 2 )
    error("Swap: Expects 2 arguments given %d.", length(args));
  endif

  t1 = args{1};
  t2 = args{2};

 if( !isscalar(t1) || !isscalar(t2) || !isNat(t1) || !isNat(t2) )
  error("Swap: targets must be natural \
numbers. Given tar1=%f and tar2=%f.",t1,t2);
  ## don't self-swap
 elseif( t1 == t2 )
   error("Swap: targets cannot be the same.");
 endif

  t  = [max(t1,t2),min(t1,t2)];
  t1 = t(1);
  t2 = t(2);

endfunction

function t = parseMeasure(args)
  if( length(args) != 1)
    error("Measure: Expected one argument, given %d.", length(args));
  endif

  t  = args{1};

  ## vector check
  if( !isvector(t) )
     error("Measure: target must be a vector or scalar.");
  ## Nat check
  elseif( !isNat(t) )
     error("Measure: targets must be natrual numbers");
  ## no-dup check
  elseif( length(unique(t)) != length(t) )
    error("Measure: target vector contains duplicates");
  endif

  t = sort(t,"descend");

endfunction

function [o,t,c] = parseCU(args)

 if( length(args) != 3 )
   error("CU: Expected three arguments given %d.",length(args));
 endif

 o = args{1}; # op spec
 t = args{2}; # target index
 c = args{3}; # ctrl index
 p = []; ## params place holder

 ## op spec check
 if( !ischar(o) && !iscell(o) )
   error("CU: Operator specifier must be string or cell array.");
 elseif( ischar(o) && !ismember(o, {"I","X","Y","Z","S","T","H" ...
                                    "I'","X'","Y'","Z'","S'","T'","H'"}))
   error("CU: Expecting QASM operator and given something else");
 elseif( iscell(o) && length(o) == 1 && ...
         !ismember(o{1},{"I","X","Y","Z","S","T","H" ...
                         "I'","X'","Y'","Z'","S'","T'","H'"}))
   error("CU: Expecting QASM operator and given something else");
 elseif( iscell(o) && length(o) == 2 && ...
         !ismember(o{1},{"PhAmp","Rn","ZYZ"}) )
   error("CU: Expecting QIASM operator and given something else");
 endif
 ## op spec is good

 ##  reuse single qubit parsers to verify target and params
 if(iscell(o) && length(o) == 1)
   parseQASM(o{1},{t});
 elseif(iscell(o) && length(o) == 2)
   parseQIASM(o{1},{o{2},t});
 else ##ischar
   parseQASM(o,{t});
 endif

 ## repack string spec as char spec
 if( ischar(o) )
   o = {o};
 endif

 if( !isNat(c) || t==c )
   error("CU: Target and Control cannot match");
 endif

endfunction

%!test
%! assert(eq(@QIRtoffoli(0,[2,1]), QIR("Toffoli",0,[1,2]) ));
%! assert(eq(@QIRfredkin([1,0],2), QIR("Fredkin",0:1,2)));
%! assert(eq(@QIRswap(2,1), QIR("Swap",1,2)));
%! assert(eq(@QIRmeasure(2:-1:0), QIR("Measure",0:2)));
%! assert(eq(@QIRcU(0,1,{"X"}),QIR("CNot",0,1)));
%! assert(eq(@QIRcU(0,1,{"Z"}),QIR("CU",{"Z"},0,1)));
%! assert(eq(@QIRcU(0,1,{"Z"}),QIR("CU","Z",0,1)));
%! assert(eq(@QIRcU(0,1,{"PhAmp",pi/3*ones(1,3)}), ...
%!           QIR("CU",{"PhAmp",pi/3*ones(1,3)},0,1)));
%! assert(eq(@QIRsingle("H",2),QIR("H",2)));
%! assert(eq(@QIRsingle("T'",2),QIR("T'",2)));
%! assert(eq(@QIRsingle("PhAmp",1,[pi/3,pi/3,pi/3]), ...
%!           QIR("PhAmp",[pi/3,pi/3,pi/3],1)))
%! assert(eq(@QIRsingle("PhAmp",1,[pi/3,pi/3,pi/3,pi/4]), ...
%!           QIR("PhAmp",[pi/3,pi/3,pi/3,pi/4 ],1)))
%! assert(eq(@QIRsingle("ZYZ",1,[pi/3,pi/3,pi/3]), ...
%!           QIR("ZYZ",[pi/3,pi/3,pi/3],1)))
%! assert(eq(@QIRsingle("ZYZ",1,[pi/3,pi/3,pi/3,pi/4]), ...
%!           QIR("ZYZ",[pi/3,pi/3,pi/3,pi/4 ],1)))
%! assert(eq(@QIRsingle("Rn",1,[pi/3,sqrt(1/3),sqrt(2/3),0]), ...
%!           QIR("Rn",[pi/3,sqrt(1/3),sqrt(2/3),0],1)))

## Need to test error checking
