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

## Compute the set of all unique length len sequences of H,T,T'. Sequences
## are simplified to sequecnes involving H,T,T',S,S',X,Y,Z

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM

function tab = computeuzero(len)
  ## maybe get some speedup
  ignore_function_time_stamp("all");

  ## add package parent directory to the path
  addpath ../qcs/inst/;

  ## Gate sets
  ## elementary gate set
  elemset = {"X","Y","Z","S","S'","H","T","T'",};
  ## SK-algo gate set... variable?
  gates = {"H","T","T'"};

  ## File names
  ## result file names
  resfilename = sprintf("uzero%02d.mat",len);
  ## logfile name
  logname = sprintf("computeuzero%02d.log",len);

  ## remove old log
  fid=fopen(logname,"w");
  fclose(fid);

  ## let's do this...
  logmsg("computeuzero script started",logname);

  if( len <= 4)
    tab = computedirect(len,gates,elemset,logname);
  elseif(uint32(floor(log2(len))) == uint32(ceil(log2(len))))

    ## number of doublings needed
    iters = uint32(floor(log2(len)))-2;

    tab = computedirect(4,gates,elemset,logname);
    for k = 1:iters
      next = double(tab,elemset);
      next = removedupes(next,logname);
      tab = next;
    endfor

 else # len>4 but not power of 2
    lhsize = 2^uint32(floor(log2(len))); # nearst power of 2 to len
    rhsize = len-lhsize; # what's left

    ## this scales poorly. when rhsize = lhsize-1,
    ## then a fair ammount of repeated computation can take place
    tab = compose(computeuzero(lhsize),...
		  computeuzero(rhsize),...
		  elemset);
    tab = removedupes(tab,logname);

  endif

  ## save to file for use by compiler
  global UZERO = tab;
  ## numeric sequences to string sequences for compilation
  for k = 1:length(UZERO)
    UZERO{k,1} = stringify(UZERO{k,1},elemset);
  endfor
   ## save as global for use in quantum compiler
  save(resfilename,"UZERO");
  clear -g UZERO;


  ignore_function_time_stamp("none");
endfunction

function uz = computedirect(len,gates,elemset,logname)

  ## allocate 2D cell array
  uz = cell(length(gates)^len,2); ## the cell array
  uz(:,1) = zeros(1,len); ## column one. vectors
  uz(:,2) = zeros(2,2); ## column two, 2x2 matrix

  logmsg("initial space allocated",logname);

  ## for each..
  for k = 1:length(uz)
    ## encode sequence as base |gates| number
    uz{k,1} = base10toradk(k-1,length(gates),len);

    ## convert [1,|gates|] to [1,|elemset|] to avoid
    ## gates/elemset order dependence
    uz{k,1} = adjustForgates(uz{k,1},gates,elemset);

    ## algebraic simplification
    uz{k,1} = simpseq(uz{k,1},elemset);

    ## compute matrix & reduce to SU(2)
    uz{k,2} = ldig2mat(uz{k,1},elemset);

  endfor

  logmsg("Complete space of %d sequences generated. Removing \
	 %duplicates",...
	 logname);

  uz = removedupes(uz,logname);

endfunction

##### Helper FUNCTIONS

function v = adjustForgates(n,gates,elemset)

  v = zeros(1,length(n));
  for k = 1:length(v)
    v(k) = find(ismember(elemset,gates{n(k)}));
  endfor

endfunction


## for logging script progress
function logmsg(msg,logname)
  fid = fopen(logname,"a");
  fprintf(fid,"%s : %s\n", datestr(fix(clock)),msg);
  fclose(fid);
endfunction

function cseq = stringify(seq,elemset)
  cseq = cell(1,length(seq));

  for k = 1 : length(seq)
    cseq{k} = elemset{seq(k)};
  endfor
endfunction

function nr = base10toradk(nat,rad,len)

  ## allocate vector
  nr = zeros(1,len);

  ##what's the high order bit?
  hob = uint32(floor(log(nat)/log(rad)))+1;

  ## just in case
  assert(hob <= len);

  ## compute digits
  for k = 1:hob
    nr(len+1-k) = mod(nat,rad);
    nat = idivide(nat,rad);
  endfor
  ## offset s.t. the values index gates/elemset
  nr = nr+1;
endfunction

## base |gates| number -> matrix
function U = ldig2mat(ldig,elemset)

  U = eye(2);

  for k = 1:length(ldig)
    U = U*eval(elemset{ldig(k)},'error("bad operator")');
  endfor
  ## factor out global phase
  U = su2afy(U);

endfunction


## takes a cellarray containing a sequence of
## G = {H,T,T'} and reduces the sequence to a shorter
## but equivalent sequence utilizing Union(G,{X,Z,S,S'})

## main function to reduce sequence. keep going until
## it stops getting shorter
function snew = simpseq(seq,elemset)

  redux = true;
  snew = seq;
  len = length(snew);
  while(redux)
    snew = reduceseq(snew,elemset);
    redux  = (len > length(snew));
    len = length(snew);
    snew = substseq(snew,elemset);
    redux  = (len > length(snew));
    len = length(snew);
  endwhile

endfunction

## sliding windows looking for seq*seq' = I
function sseq = reduceseq(seq,elemset)
  len = length(seq);

  size = 1;
  while(size <= uint32(length(seq)/2) )
    curr = 1; ## current index
    found = false; ## true if subsequence is removed
    ## step through and remove U*U'=I
    while(curr+2*size-1 <= length(seq) )

      if(isadjoint( seq(curr:curr+size-1), ...
		    seq(curr+size:curr+2*size-1),...
		    elemset))
	## remove subseq
	idxs = [[1:curr-1],[curr+2*size:length(seq)]];
	seq = seq(idxs);
	## flag found
	found = true;
      else
	curr++;
      endif

    endwhile

    ## no sequences found, lets try larger sequence
    if(!found)
      size = size * 2;
    endif
    ## when sequences are found, we repeat for same size

  endwhile

  sseq = seq;
endfunction

## true if aseq*bseq = "I". Works on strings (op names)
## and cell array seqences of strings.  Only accounts for
## {H,Z,T,S,T',S',X,Y}
function b = isadjoint(aseq,bseq,elemset)

  len = length(aseq);
  for k = 1:len
    if( !adjop(elemset{aseq(k)},elemset{bseq(len+1-k)}) )
      b = false;
      return;
    endif
  endfor
  b=true;

endfunction

function b = adjop(astr,bstr)
    b = (strcmp(astr,"H") && strcmp(astr,bstr)) || ...
	(strcmp(astr,"Z") && strcmp(astr,bstr) ) || ...
	(strcmp(astr,"X") && strcmp(astr,bstr) ) || ...
	(strcmp(astr,"Y") && strcmp(astr,bstr) ) || ...
	( strcmp(astr,"T") && strcmp(bstr,"T'") ) || ...
	( strcmp(astr,"T'") && strcmp(bstr,"T") ) || ...
	( strcmp(astr,"S'") && strcmp(bstr,"S") ) || ...
	( strcmp(astr,"S") && strcmp(bstr,"S'") )  ;
endfunction


## for |seq|==2, replace with eqivalent sequence of
## length 2 or 1.. T^2 =S,S^2=Z
## changing global elementset breaks this function!!!
function snew = substpair(seq,elemset)

  if(strcmp(elemset{seq(1)},elemset{seq(2)}))
    switch (elemset{seq(1)})
      case "T"
	snew = [find(ismember(elemset,"S"))]; #S
      case "T'"
	snew = [find(ismember(elemset,"S'"))]; #S'
      case {"S","S'"}
	snew = [find(ismember(elemset,"Z"))]; #Z
      otherwise
	snew=seq;
    endswitch
  else
    snew = seq; #no change
  endif
endfunction

## reduces HZH=X and HXH=Z
function snew = subshxz(seq,elemset)

  snew = seq;
  if(strcmp(elemset{seq(1)},elemset{seq(3)})...
     && strcmp(elemset{seq(1)},"H"))
        ## convert to strings

    if(strcmp(elemset{seq(2)},"Z") )
      snew = [find(ismember(elemset,"X"))]; #X
    elseif(strcmp(elemset{seq(2)},"X"))
      snew = [find(ismember(elemset,"Z"))]; #Z
    else
      snew = seq; # no change
    endif

  else
    snew = seq;
  endif

endfunction

function snew = substseq(seq,elemset)
  snew = seq;
  found = true;
  ## repeat until no more subst is found
  while(found)

    found = false;
    ## pairwise reductions (and len 2^k reductions)
    k=1;
    while(k<length(snew))
      curr = substpair(snew(k:k+1),elemset);
      if(length(curr) == 1)
	snew = [snew(1:k-1),curr(1),...
		snew(k+2:end) ];
	found=true;
      endif
      k++;
    endwhile

    ## look for HXH=Z and HZH=X
    k=1;
    while(k<(length(snew)-1))
      curr = subshxz(snew(k:k+2),elemset);
      if(length(curr) == 1)
	snew = [snew(1:k-1),curr(1),...
		snew(k+3:end)];
	found = true;
      endif
      k++;
    endwhile
  endwhile

endfunction

function U = su2afy(mat)

  U = zeros(2,2);

  ph = det(mat);
  if( ph != 1 ) # must be U(2). factor out global phase
    U = sqrt(ph)' * mat;
  else # already SU(2)
    U = mat;
  endif

endfunction

function newus = removedupes(uz,logname)
  ## remove duplicates
  iter = 1; ## num iterations --> 1+[unique-so-far]

  urows = 1:length(uz); ## index of unique rows

  while ( iter<length(urows) )


    uni = zeros(1,length(urows)-iter);
    curr = uz{urows(iter),2};

    for k = 1:length(uni)
      ## true if not within eta of curr
      ## Is this a fair 'equality check'?
      uni(k) = (10^(-8) < norm(uz{urows(k+iter),2}-curr));
    endfor

    ## new size = iter unique + sum(uni) possibly unique
    posUni = sum(uni);
    dupes = length(urows) - posUni;
    urows = urows([1:iter,(find(uni)+iter)]);

    logmsg(sprintf("found %d duplicates on iteration %d. %d remain.", ...
		   dupes,iter,posUni), logname);

    ## indices of new elements
    iter++; ## next item
  endwhile
  newus = uz(urows,:); ## select unique

  logmsg(sprintf("Finished removing duplicates %d unique items found.",...
		 length(newus)),...
	 logname);

endfunction

function newus = double(us,elemset)

  len = length(us);
  newus = cell(len^2,2);
  newus(:,2) = zeros(2);
  for k = 1:len
    for j = 1:len
      idx = (k-1)*len+j;
      ## simplify again to handle the composition
      newus{idx,1} = simpseq([us{k,1},us{j,1}],elemset);
      ## compute from sequence for consistency
      newus{idx,2} = ldig2mat(newus{idx,1},elemset);
    endfor
  endfor

endfunction

function newus = compose(lhs,rhs,elemset)

  lenl = length(lhs);
  lenr = length(rhs);

  newus = cell(lenl*lenr,2);
  newus(:,2) = zeros(2);

  for k = 1:lenl
    for j = 1:lenr
      idx = (k-1)*lenr+j;
      ## simplify again to handle the composition
      newus{idx,1} = simpseq([lhs{k,1},rhs{j,1}],elemset);
      ## compute from sequence for consistency
      newus{idx,2} = ldig2mat(newus{idx,1},elemset);
    endfor
  endfor


endfunction
