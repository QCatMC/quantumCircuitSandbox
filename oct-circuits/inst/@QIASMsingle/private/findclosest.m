## Search the precomputed approximations to find the one closest to
## U.
## eww globals... is there a better way for some persistant, shared state?
function [seq,mat] = findclosest(U)

  ## UZERO is the 'table' of precomputed sequences
  ## it's loaded by @QIASMcircuit compile 
  ## it's computed by @QIASMcircuit/private/computeuzero.m script
  ## it's stored in @QIASMcircuit/private/uzero.mat
  global UZERO; # format (seq,U(2))
  
  ## search UZERO for the closest U(2)
  errs = cellfun(@(V) norm(U-V),UZERO(:,2));  #get errors
  [minVal,minIdx] = min(errs); ## find min
  mat = UZERO{minIdx,2}; ## select matrix
  seq = UZERO{minIdx,1}; ## select sequence
  
  
endfunction
