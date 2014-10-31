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

## usage: [Us,newU] = skalgo(U, n)
##
## Compute an eta(n) approximation to the unitary U using
## the Solovay-Kitaev Algorithm. newU is the approximation and Us is
## the sequence of elementary operators,as strings, which computes 
## that operator. Algorithm based off paper by Dawson&Nielsen 
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators 

function [Us,newU] = skalgo(U,n)
  
  if( n == 0 )
    ## UZERO is a table of (strseq,U(2)) pairs
    ## findclosest picks the pair that minimizes
    ## operr(U,U(2))
    [Us,newU] = findclosest(U);
  else
    [Unm1seq,Unm1] = skalgo(U,n-1);
    [V,W] = getGroupComm(U*Unm1');
    [Vnm1seq,Vnm1] = skalgo(V,n-1);
    [Wnm1seq,Wnm1] = skalgo(W,n-1);

    ## compute new operator matrix
    newU = Vnm1*Wnm1*Vnm1'*Wnm1'*Unm1;

    ## construct sequence for that matrix

    ##  adjoint sequences
    VseqAdj = cell(length(Vnm1seq),1);
    len = length(VseqAdj);
    for k = 1:len
	VseqAdj{k} = adj(Vnm1seq{len+1-k});
    endfor

    WseqAdj = cell(length(Wnm1seq),1);
    len = length(WseqAdj);
    for k = 1:len
	WseqAdj{k} = adj(Wnm1seq{len+1-k});
    endfor

    ## U = V*W*V'*W'*Un-1
    Us = {Vnm1seq{:},Wnm1seq{:}, VseqAdj{:}, WseqAdj{:}, Unm1seq{:}};

  endif
  
endfunction

## Adjoint by name/string
## this is a bit hacky... but should work... 
function s = adj(opstr)

  if(length(opstr) == 2) #only U'->U
    s = opstr(1);
  else #length is 1. U->U', unless it's Hermitian
    switch(opstr)
      case {"H","X","Y","Z","I"}
	s=opstr;
      otherwise
	s = [opstr,"'"];
    endswitch
  endif

endfunction

## compute 0:dep approximations of a large number of SU(2) 
##  operators and verify that they get increasingly better
##   - only executable from @QIASMsingle/private
##   - will take a fair bit of time 

%!test
%! ## get the currently utilized U0 table
%!
%! load("../../@QIASMcircuit/private/uzero.mat");
%! addpath("../../");
%!
%! amp = (0:(pi/2/8):pi/2)'; #[0,pi/2]
%! pha = (0:(pi/8):(15*pi/8))'; #[0,2*pi)
%! ## phase/amp parameters for some SU(2) operators
%! params = [kron(amp,ones(length(pha),1)),...
%!           kron(pha,ones(length(amp),1)),...
%!           kron(ones(length(amp),1),pha)];
%!
%! #save "skalgoTestData.mat" params; #write params to file
%!
%! eqTol = 2^(-20);
%! dep = 2;
%! etas = zeros(length(params),dep+1);
%! for k = 1:length(params)
%!   U = U2phaseamp(params(k,:));
%!   for j = 0:dep
%!     [s,u] = skalgo(U,j); #zero approximation
%!     etas(k,j+1) = norm(U-u); #eta-j error
%!   endfor
%! endfor
%! #save -append "skalgoTestData.mat" etas; # write etas to file
%! ediffs = diff(etas,1,2);
%! #save -append "skalgoTestData.mat" ediffs; #write diffs
%! res = ediffs <= 0; # check for monotonic decrease
%! #save -append "skalgoTestData.mat" res; # write monotonic check
%! resS = find(sum(res,2)!= dep);
%! assert(length(resS)==0,"Failed on %d operators",length(resS));
%! rmpath("../../");
%! clear -g all;

    

    
