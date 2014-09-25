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

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM

## length of sequences
global lzero = 3;

## gate set
global gates = {"H","T","T'"};

## nat is base 10 integer
## convert to row vector corresponding to a
## k digit, base rad representation of nat
##   Not error checked !!
function nr = base10toradk(nat,rad,k)
  nr = zeros(1,k);
  
  while ( nat > 0 )
    nr(k) = mod(nat,rad);
    nat = idivide(nat,rad,"floor");
    k = k-1;	
  endwhile
  
endfunction

## operator index to string
function opstr = opinttostr(opint)
  global gates;
  if( opint > length(gates) )
    error("whoops");
  else
    opstr = gates(opint+1);
  endif

endfunction

## convert string sequence to matrix
function U = strseq2mat(strseq)
  U = eye(2);
  for k = 1:length(strseq)
    U = U*eval(strseq{k},'error("bad operator")');
  endfor
endfunction

## for logging script progress
function log(msg)
  fid = fopen("computeeta.log","a");
  fprintf(fid,"%s : %s\n", datestr(fix(clock)),msg);
  fclose(fid);
endfunction

### **** BEGIN Script **** ###

## add package parent directory to the path
addpath ../../;
## remove old log
fid=fopen("computeeta.log","w");
fclose(fid);

## let's do this...

log("computeeta script started");
## allocate 2D cell array
global ETAZERO = cell(length(gates)^lzero,2);
log("initial space allocated");

## op sequences as base |gates|, fixed length, numbers
ETAZERO(:,1) = arrayfun(@(n) base10toradk(n,length(gates),lzero), ...
		[0:(length(gates)^lzero-1)]',...
		"UniformOutput",false);
log("sequence vectors created");

## convert to char sequences 
ETAZERO(:,1) = cellfun(@opinttostr,ETAZERO(:,1),"UniformOutput",false);
log("vectors converted to strings");

## compute operator matrix
ETAZERO(:,2) = cellfun(@(s) strseq2mat(s),ETAZERO(:,1),...
		       "UniformOutput",false);

log("operators computed. Beginning reduction process.");

## Now simplify... remove duplicates,simplify sequences

iter = 1; ## num iterations
urows = 1:length(ETAZERO); ## index of unique rows 

## ETAZERO(1:iter-1) are not duplicated in ETAZERO(iter:end) 
while ( iter<length(urows) )
  ## find all items not equal to 
  uni = cellfun(@(mat) !isequal(mat,ETAZERO{iter,2}), ...
		 ETAZERO(:,2));
  numuni = sum(uni)+1;

  log(sprintf("found %d duplicates on iteration %d. %d remain.", ...
	      (length(urows)-numuni),iter,numuni));


  urows = union(find(uni),[iter]); ## indices of unique elements
  ETAZERO = ETAZERO(urows,:); ## select unique
  iter++; ## next item
endwhile

log(sprintf("Finished removing duplicates %d unique items found.",...
	    length(ETAZERO)))

save etazero.mat ETAZERO;

## clean up 
clear;

