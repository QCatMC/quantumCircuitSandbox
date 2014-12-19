
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

        if( norm( SUin-tab{l,2} ) < 2^-30 )  #if conj
          ## set indexes
          tab{l,3} = k;
          tab{k,3} = l;
          break; # stop loop
        endif
      endfor
    endif

  endfor

  ## get the index for all operators with conjugate in the table
  keepers = cell2mat(tab(:,3)) !=0;
  numkeep = sum(keepers) ## report this
  oldIdx = find(keepers); ## idx of keepers in old tab
  newIdx = cumsum(keepers); ## idx of keepers in new tab

  ## grab the keepers
  tab = tab(oldIdx,:);
  ## rewrite pointers to conjugates
  for k = 1:rows(tab)
    tab{k,3} = newIdx(tab{k,3});
  endfor

  ## double check pointers
  assert(isequal((1:rows(tab))', ...
                  sort(cell2mat(tab(:,3)))));


  global UZERO = tab;
  save(tname,"UZERO");
  clear -g UZERO;

endfunction
