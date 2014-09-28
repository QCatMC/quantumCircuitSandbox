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


### KEY VARIABLES 

## length of sequences
global lzero = 4;
## gate set
global gates = {"H","T","T'"};

## result file names
global logname = sprintf("computeuzero%d.log",lzero);  
resfilename = sprintf("uzero%d.mat",lzero);

##### FUNCTIONS

## for logging script progress
function logmsg(msg)
  global logname;
  fid = fopen(logname,"a");
  fprintf(fid,"%s : %s\n", datestr(fix(clock)),msg);
  fclose(fid);
endfunction


## nat is base 10 integer
## convert to row vector corresponding to a
## k digit, base rad representation of nat
##   Not error checked !!
function nr = base10toradk(nat)
  global lzero;
  global gates;

  gits = lzero;
  rad = length(gates);

  nr = zeros(1,gits);
  
  while ( nat > 0 )
    nr(gits) = mod(nat,rad);
    nat = idivide(nat,rad,"floor");
    gits = gits-1;	
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

## true if mat is not UZERO{iter}
function b = isnotiter(mat)

  global UZERO;
  global iter;

  b = 10^(-10) < norm(mat-UZERO{iter,2});

endfunction


### **** BEGIN Script **** ###

## add package parent directory to the path
addpath ../../;
## remove old log
fid=fopen(logname,"w");
fclose(fid);

## let's do this...
logmsg("computeeta script started");

## allocate 2D cell array
global UZERO = cell(length(gates)^lzero,2);
logmsg("initial space allocated");

## op sequences as base |gates|, fixed length, numbers
UZERO(:,1) = arrayfun(@base10toradk,[0:(length(gates)^lzero-1)]',...
			"UniformOutput",false);
logmsg("sequence vectors created");

## convert to char sequences 
UZERO(:,1) = cellfun(@opinttostr,UZERO(:,1),"UniformOutput",false);
logmsg("vectors converted to strings");

## compute operator matrix
UZERO(:,2) = cellfun(@strseq2mat,UZERO(:,1),...
		       "UniformOutput",false);

## save full set of sequences
save(resfilename,"UZERO");
logmsg("operators computed and written to file. Beginning reduction process.");


## Now simplify... remove duplicates

global iter = 1; ## num iterations
urows = 1:length(UZERO); ## index of unique rows 

## UZERO(1:iter-1) are not duplicated in UZERO(iter:end) 
while ( iter<length(UZERO) )

  ## find all items in (iter+1:end) not equal to item at iter
  uni = cellfun(@isnotiter,UZERO(iter+1:length(UZERO),2));
  ## total unique items found
  numuni = sum(uni)+iter; 

  logmsg(sprintf("found %d duplicates on iteration %d. %d remain.", ...
	      (length(UZERO)-numuni),iter,numuni));

  ## indices of unique elements
  urows = [[1:iter]'(:);(iter+find(uni))(:)]; 
  
  UZERO = UZERO(urows,:); ## select unique  
  
  ## save to file every so often on longer jobs
  if( mod(iter,50) == 0 )
    logmsg(sprintf("Current %d elements saved to file.",length(UZERO)));
    save(resfilename,"UZERO");
  endif

  iter++; ## next item
endwhile

logmsg(sprintf("Finished removing duplicates %d unique items found.",...
	    length(UZERO)))

addpath ../../@QIASMsingle/private/;

UZERO(:,1) = cellfun(@simpseq,UZERO(:,1),"UniformOutput",false);

logmsg("Sequence simplification complete. Writing finished product to file.");

save(resfilename,"UZERO");

## clean up 
clear;

