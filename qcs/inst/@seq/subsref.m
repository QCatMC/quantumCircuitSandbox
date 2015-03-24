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
## @deftypefn {Function File} {} subsref {}
##
## THIS FUNCTION IS NOT INTENDED FOR DIRECT USE BY QCS USERS.
##
## @end deftypefn

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: circuits

function C = subsref(this,idx)

  switch(idx(1).type)

    case "()"

      subs = idx(1).subs;

      ## depth 1 selection
      if( length(subs) == 1 || (length(subs) == 2 && subs{2}==1) )

        steps = subs{1};
        if( !isvector(steps) ||  !isnat(steps) )
          error("subsref: Steps must be a vector of positve natural numbers");
        elseif( max(steps) > stepsat(this,1) )
          error("subsref: Max step exceeds number of steps");
        else
          seq = get(this,"seq");
          C = @seq(seq(steps));
        endif

      ## depth > 1 selection
      elseif( length(subs) == 2 )

        steps = subs{1};
        depth = subs{2};

        ## check depth
        if( !isscalar(depth) || !isnat(depth) )
          error("subsref: depth must be positive natural number.")
        #elseif( depth > get(this,"maxdepth") )
        #  error("subsref: depth exceeds circuit max depth");
        endif
        ## depth OK

        ## check steps
        if( !isvector(steps) || !isnat(steps) )
          error("subsref: Steps must be a vector of positve natural numbers");
        elseif( max(steps) > stepsat(this,depth) )
          error("subsref: Max step exceeds number of steps for given depth");
        endif
        ## steps OK

        ## now gather the gates...

        ## seq: the cell array of Gates/Seqs
        seq = get(this,"seq");

        ## dSteps(i) is the number of steps, w.r.t. depth, at seq{i}
        dSteps = zeros(1,length(seq));
        for k = 1:length(dSteps)
          dSteps(k) = stepsat(seq{k},depth-1);
        endfor

        ## stepsUpTo(i) is the total number of steps, w.r.t. depth, for
        ##  seq{1:i}
        stepsUpTo = cumsum(dSteps);

        ## steps(i) can be found at seq{isAt(i)}
        isAt = lookup(stepsUpTo,steps-1)+1;

        newseq = cell();
        currHigh=1;
        currLow=1;

        while( currHigh <= length(steps) )
          ## save current step index
          currLow=currHigh;
          ## advance high
          currHigh++;
          ## keep collecting adjacent steps in same element of seq
          while( currHigh <= length(steps) && isAt(currHigh) == isAt(currLow) )
            currHigh++;
          endwhile

          ## isAt(currLow:currHigh-1) are all equivalent, i.e.
          ## seq{currLow:currHigh-1} contains steps(currLow:currHigh-1)

          ## now select the subset of steps that are found in the same element
          ## of seq.
          substeps = steps(currLow:(currHigh-1));

          ## if the element is a gate, the collect it, repeatedly if needed
          if( dSteps(isAt(currLow)) == 1 )
            newseq = {newseq{:},seq{isAt(currLow)*ones(1,length(substeps))}};
            ## pushing might be faster...
            ##for w = 1:length(substeps)
            ##  newseq{end+1} = seq{isAt(currLow)};
            ##endfor

          ## the element is a sequence, so recurse
          else
            ## offset substeps if they're not in seq{1}
            if(isAt(currLow) > 1 )
              substeps =  -stepsUpTo(isAt(currLow)-1) + substeps;
            endif

            ## recurse on the sub sequence
            subseq = seq{isAt(currLow)};
            idx.type = "()";
            idx.subs = {substeps,depth-1};
            newseq{end+1} = subsref(subseq,idx);
          endif

        endwhile
        C = @seq(newseq);
      else
        error("Can only select subcircuits by steps and depth");
      endif

    otherwise
      error("invalid subscript type");

  endswitch

endfunction

function b = isnat(n)

  for k = 1:length(n)
    if(!isscalar(n(k)) || floor(n(k))!=ceil(n(k)) || n(k) < 1 )
      b = false;
      return;
    endif
  endfor

  b=true;
endfunction


%!test
%! S = @seq({QIR("H",0),QIR("Z",1),@seq({QIR("CNot",0,1),QIR("Z",2)})});
%! assert(eq(S,S(1:3)));
%! assert(eq(@seq({QIR("H",0)}),S(1)));
%! assert(eq(@seq({QIR("Z",1)}),S(2)));
%! assert(eq(@seq({@seq({QIR("CNot",0,1),QIR("Z",2)})}),S(3)));
%! assert(eq(@seq({QIR("H",0),@seq({QIR("CNot",0,1),QIR("Z",2)})}), ...
%!           S([1,3]) ))
%! assert(eq(S,S(1:3,1)));
%! assert(eq(@seq({QIR("H",0)}),S(1,1)));
%! assert(eq(@seq({QIR("Z",1)}),S(2,1)));
%! assert(eq(@seq({@seq({QIR("CNot",0,1),QIR("Z",2)})}),S(3,1)));
%! assert(eq(@seq({QIR("H",0),@seq({QIR("CNot",0,1),QIR("Z",2)})}), ...
%!           S([1,3],1) ))
%!
%! assert(eq(S([4,3],2),@seq({@seq({QIR("Z",2),QIR("CNot",0,1)})}) ));
%! assert(eq(S,S(1:4,2)));
%! assert(eq(@seq({QIR("H",0)}),S(1,2)));
%! assert(eq(@seq({QIR("Z",1)}),S(2,2)));
%! assert(eq(@seq({QIR("H",0),QIR("Z",1),@seq({QIR("Z",2)})}),S([1,2,4],2)));

%!test
%! R = @seq({QIR("H",0),QIR("H",1),QIR("H",2),QIR("H",3)});
%! S = @seq({R,R,R,R});
%! assert(eq(@seq({R}),S(1)));
%! assert(eq(@seq({R}),S(3)));
%! assert(eq(@seq({R}),S(4)));
%! assert(eq(@seq({@seq({QIR("H",1)}),@seq({QIR("H",2)})}), ...
%!           S([2,7],2)));
%! assert(eq(@seq({@seq({QIR("H",1)}),@seq({QIR("H",2)})}), ...
%!           S([6,11],2)));
%! assert(eq(@seq({@seq({QIR("H",1),QIR("H",2)})}), ...
%!           S([2,3],2)));
%! assert(eq(@seq({@seq({QIR("H",1),QIR("H",2)})}), ...
%!           S([10,11],2)));
