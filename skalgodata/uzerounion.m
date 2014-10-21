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

## used to join all the tables uzerolow.mat to uzerohigh.mat an generate
## the incremental unions of low to k for each k in (low,high]. Each
## table union is written to a file as UZERO. 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: QIASM


function uz = uzerounion(high,low=1)
  
  if( low == high)
    error("no need to union a single set");
  elseif( high < low )
    error("high should be higher than low");
  elseif( !isreal(low) || !isreal(high) || ...
	  floor(low)!= ceil(low) || floor(high) != ceil(high) )
    error("high and low must be positive integers");
  endif

  ## load in low data

  fname = sprintf("uzero%d.mat",low);
  load(fname);
  uz = UZERO;
  clear -g UZERO;

  for k = low+1:high
    ## load UZEROk
    fname = sprintf("uzero%d.mat",k);
    load(fname);
    curr = UZERO;
    clear -g UZERO;

    ## add new items from curr to uz
    for j = 1:length(curr)
      if(isunique(uz,curr{j,2}))
	uz(end+1,:) = curr(j,:);
      endif
    endfor

    ## save current uz
    rfname = sprintf("uzero%dto%d.mat",low,k);
    global UZERO = uz;
    save(rfname,"UZERO");
    clear -g UZERO;

  endfor  

endfunction

function b = isunique(uz,item)
	 
  b = true;
  for k = 1:length(uz)
    if(norm(uz{k,2}-item) < 2^(-50))
      b=false;
      return;
    endif
  endfor

endfunction
