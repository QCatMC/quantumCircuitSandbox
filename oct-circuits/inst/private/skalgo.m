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

## usage: Us = skalgo(U, n)
##
## Compute an eta(n) approximation to the unitary U using
## the Solovay-Kitaev Algorithm. 
## 

## Author: Logan Mayfield <lmayfield@monmouthcollege.edu>
## Keywords: Operators 

function Us = skalgo(U,n)
  Us = 0;
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
