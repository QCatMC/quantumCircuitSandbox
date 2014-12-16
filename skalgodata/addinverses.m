
## add a third column to uzero table that contains
## the index of the reverse of the row
function tab = addinverses(tname)

  load(tname);
  tab = cell(rows(UZERO),3);
  tab(:,1) = UZERO(:,1); # sequence
  tab(:,2) = UZERO(:,2); # matrix
  tab(:,3) = 0 ;   # index of conjugate

  clear -g UZERO;

  for k = 1:rows(tab)
    SUin = tab{k,2}'; # current SU(2) operator conjugate

    if( tab{k,3} == 0 ) # if no conj found yet
      for l = k:rows(tab) # search k and the rest

        if( norm( SUin-tab{l,2} ) < 2^-30 ) #if conj
          ## set indexes
          tab{l,3} = k;
          tab{k,3} = l;
          break; # stop loop
        endif
      endfor
    endif

  endfor

  ## sequences without conjugates... which should be none!
  noinv = find(cell2mat(tab(:,3))==0);
  for k = noinv.'
    r = cell(1,3);
    r{3} = k;
    newlen = rows(tab)+1;
    tab{k,3} = newlen;

    r{2} = tab{k,2}';

    r{1} = cell(1,length(tab{k,1}));

    for l = 1:length(tab{k,1})
      r{1}{l} = adj(tab{k,1}{l});
    endfor

    tab(end+1,:) = r;
  endfor

  noinv = find(cell2mat(tab(:,3))==0);
  assert(isempty(noinv));
  assert(isequal((1:rows(tab)).',unique(cell2mat(tab(:,3)))));


  global UZERO = tab;
  save(tname,"UZERO");
  clear -g UZERO;

endfunction

## Adjoint by name/string
## this is a bit hacky... but should work...
function s = adj(opstr)

  if(length(opstr) == 2) #only U'->U
    s = opstr(1);
  else #length is 1. U->U', unless it's Hermitian
    switch(opstr)
      case {"H","X","Y","Z","I"}
      s= opstr;
      otherwise
      s = [opstr,"'"];
    endswitch
  endif

endfunction
