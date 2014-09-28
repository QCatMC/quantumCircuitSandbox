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
    Us = {Vnm1seq{:},Wnm1seq{:}, ...
	  fliplr(cellfun(adj,Vnm1seq,"UniformOutput",false)){:}, ...
	  fliplr(cellfun(adj,Wnm1seq,"UniformOutput",false)){:}, ...
	  Unm1seq{:}};
    
  endif

endfunction

%!test
%! assert(false);

## usage: [V,W] = getGroupComm(U,ep)
##
## Compute the group commutator operators V,W such that U=VWV'W'. V
## and W are 2x2 Unitaries. Note this only works for U in SU(2) and
## operr(U,Iop) < eta for small eta (i.e. operators near I).
##  

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators

function [V,W] = getGroupComm(U,ep=0.00001)
  
  if(!isequal(size(U),[2,2]) )
    error("Operator size mismatch. Must be 2x2 Unitary.");
  elseif( operr(U*U',Iop) >  ep)
    error("Given operator doesn't appear to be be unitary");	 
  endif
  
  V=zeros(2);
  W=zeros(2);
  ## get the Rotation Parameters of U
  uRot = RnParams(U,ep);
  uAng = uRot(1);

  ## compute the rotation angle for V and W
  ## Equation from Dawson-Neilsen. Solution from Mathematica10.
  phi = 2*asin( (1-cos(uAng/2))^(1/4) / 2^(1/4) );

  ## compute V and W. No similarity transformation.
  V = Rx(phi);
  W = Ry(phi);
  ## get the group commutator (again no S).
  gc = V*W*(V')*(W');
  ## Compute the similarity transform for the SU(2) base for U and gc
  S = getSimTrans(U,gc);
  ## Recompute V and W
  V = S'*V*S;
  W = S'*W*S;
  
endfunction

%!test
%! assert(false)

## compute a similary transform S s.t. U = S'*V*S;
function S = getSimTrans(U,V)
	 
  S = zeros(2);
  ## get Rn parameters for U and V
  pU = RnParams(U);
  pV = RnParams(V);

  ## rotation axis
  uB = pU(2:4);
  vB = pV(2:4);

  ## get and normalize a perpendicular vector
  sB = cross(uB,vB);
  sB = sB/norm(sB);
  
  ## get rotation distance between U & V
  sphi = acos(vB*uB');
  
  ## Similarity Matrix: rotate phi about the perpendicular 
  S = Rn(sphi,sB);
	 
endfunction

## Adjoint by name/string
## this is a bit hacky... but should work... 
function s = adj(opstr)
  if(length(optstr) == 2)
    s = opstr(1);
  else #length is 1
    s = [opstr,"'"];
  endif
endfunction


## Search the precomputed approximations to find the one closest to
## U.
## eww globals... is there a better way for some persistant, shared state?
function [seq,mat] = findclosest(U)

  ## UZERO is the 'table' of precomputed sequences
  ## it's loaded by @QIASMcircuit compile 
  ## it's computed by @QIASMcircuit/private/computeuzero.m script
  ## it's stored in @QIASMcircuit/private/uzero.mat
  global UZERO; # format (seq,U(2))
  
  ## search ETAZERO for the closest SU(2)
  errs = cellfun(@(V) norm(U-V),UZERO(:,2));  #get errors
  [minVal,minIdx] = min(errs); ## find min
  mat = UZERO{minIdx,1}; ## select matrix
  seq = UZERO{minIdx,2}; ## select sequence
  
  ##assert(operr(mat,U) >= ETA0);
  
endfunction
