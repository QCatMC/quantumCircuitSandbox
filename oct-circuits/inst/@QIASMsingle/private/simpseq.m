
## takes a cellarray containing a sequence of 
## {H,Z,T,T',S,S'} and reduces the sequence to a shorter
## but equivalent sequence

function snew = simpseq(seq)

  redux = true;
  snew = seq;
  len = length(snew);
  while(redux)
    snew = reduceseq(snew); 
    redux  = (len > length(snew));
    len = length(snew);
    snew = substseq(snew);
    redux  = (len > length(snew));
    len = length(snew);
  endwhile

endfunction

## sliding windows looking for seq*seq' = I
function sseq = reduceseq(seq)
  len = length(seq);

  size = 1;
  while(size <= uint32(length(seq)/2) )
    curr = 1; ## current index 
    found = false; ## true if subsequence is removed
    ## step through and remove U*U'=I
    while(curr+2*size-1 <= length(seq) )

      if(isadjoint(seq(curr:curr+size-1),seq(curr+size:curr+2*size-1)))
	## remove subseq
	idxs = [ [1:curr-1],[curr+2*size:length(seq)] ];
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
## {H,Z,T,S,T',S'}
function b = isadjoint(aseq,bseq)
  b=false;
  if(ischar(aseq) && ischar(bseq))
    b = (strcmp(aseq,"H") && strcmp(aseq,bseq)) || ...
	(strcmp(aseq,"Z") && strcmp(aseq,bseq) ) || ...
	( strcmp(aseq,"T") && strcmp(bseq,"T'") ) || ...
	( strcmp(aseq,"T'") && strcmp(bseq,"T") ) || ...
	( strcmp(aseq,"S'") && strcmp(bseq,"S") ) || ...
	( strcmp(aseq,"S") && strcmp(bseq,"S'") )  ;
  elseif(iscell(aseq) && iscell(bseq))
    if(length(aseq) != length(bseq))
      b= false;
    else
      b = length(aseq) == sum(cellfun(@isadjoint, 
				      aseq,fliplr(bseq)));		      
    endif
  endif

endfunction 

## for |seq|==2, replace with eqivalent sequence of 
## length 2 or 1.. T^2 =S,S^2=Z
function snew = substpair(seq)
  snew=seq;	 
  if(strcmp(seq{1},seq{2}))
    switch (seq{1})
      case "T"
	snew = {"S"};
      case "T'"
	snew = {"S'"};
      case {"S","S'"} 
	snew = {"Z"};
    endswitch
  endif

endfunction

function snew = substseq(seq)
  snew = seq;	 
  found = true;
  ## repeat until no more subst is found
  while(found)
    k=1;
    found = false;
    while(k<length(snew))
      curr = substpair(snew(k:k+1));
      if(length(curr) == 1)
	snew = {snew{1:k-1},curr{1},...
		snew{k+2:end} };
	found=true;
      endif
      k++;	     
    endwhile
  endwhile

endfunction
