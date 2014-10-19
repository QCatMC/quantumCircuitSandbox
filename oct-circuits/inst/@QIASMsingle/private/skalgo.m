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
    VseqAdj = cell(1,length(Vnm1seq));
    len = length(VseqAdj);
    for k = 1:len
	VseqAdj{k} = adj(Vnm1seq{len+1-k});
    endfor

    WseqAdj = cell(1,length(Wnm1seq));
    len = length(WseqAdj);
    for k = 1:len
	WseqAdj{k} = adj(Wnm1seq{len+1-k});
    endfor

    ## U = V*W*V'*W'*Un-1
    Us = {Vnm1seq{:},Wnm1seq{:}, VseqAdj{:}, WseqAdj{:}, Unm1seq{:}};

  endif
  
endfunction

function p = RnVals(U)

  theta = 2*acos( (U(1,1)+ U(2,2)) / 2);
  n = zeros(1,3);
  
  minval = 2^(-50); #close enough to zero

  if( abs(theta) < minval )#Identity
    theta=0;
    n(3)=1;
  ## Diagonal Matrix
  elseif( abs(U(1,2)) < minval && abs(U(2,1)) < minval ) 
    n(3) = 1;
  ## Off-Diagonal Matrix
  elseif( abs(U(1,1)) < minval && abs(U(2,2)) < minval )
    theta = pi;
    n(2) = (U(1,2)-U(2,1))/(-2);
    n(1) = (U(1,2)+U(2,1))/(-2*i);
  else
    n(3) = (U(1,1)-U(2,2))/(-2*i*sin(theta/2));
    n(2) = (U(1,2)-U(2,1))/(-2*sin(theta/2));
    n(1) = (U(1,2)+U(2,1))/(-2*i*sin(theta/2)); 
  endif

  p = [theta,n];

endfunction


## usage: [V,W] = getGroupComm(U)
##
## Compute the group commutator operators V,W such that U=VWV'W'. V
## and W are 2x2 Unitaries. Note this only works for U in SU(2) where
## norm(U-I) is very small
##  

function [V,W] = getGroupComm(U)
  
  V=zeros(2);
  W=zeros(2);
  ## get the Rotation Parameters of U
  uRot = RnVals(U);
  uAng = uRot(1);

  ## compute the rotation angle for V and W
  ## Equation from Dawson-Neilsen. Solution from Mathematica10.
  phi = 2*asin( (1-cos(uAng/2))^(1/4) / 2^(1/4) );

  ## compute V and W. No similarity transformation.
  X = [0,1;1,0];
  Y = [0,-i;i,0];  
  V = e^(-i*phi/2*X); #Rx
  W = e^(-i*phi/2*Y); #Ry

  ## get the group commutator (again no S).
  gc = V*W*(V')*(W');

  ## Compute the similarity transform for the SU(2) base for U and gc
  S = getSimTrans(U,gc);

  ## Recompute V and W
  V = S'*V*S;
  W = S'*W*S;
  
endfunction



## compute a similary transform S s.t. U = S'*V*S;
function S = getSimTrans(U,V)
	 
  S = zeros(2);
  ## get Rn parameters for U and V
  pU = RnVals(U);
  pV = RnVals(V);

  ## rotation axis
  uB = pU(2:4);
  vB = pV(2:4);

  ## better check here for same or parallel uB,vB
  if( abs(abs(vB*uB') - 1) < 0.00001) 
    S = eye(2);
  else
    ## get and normalize a perpendicular vector, if possible
    sB = cross(uB,vB);
    sB = sB/norm(sB);
    
    ## get rotation distance between U & V
    sphi = acos(vB*uB');
    
    ## Similarity Matrix: rotate phi about the perpendicular 
    X=[0,1;1,0];
    Y=[0,-i;i,0];
    Z=[1,0;0,-1];
    S = e^(-i*sphi/2*(sB(1)*X+sB(2)*Y+sB(3)*Z)); #Rn(sphi,sB)
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

## compute 0,1,2 approximations of a large number of SU(2) 
##  operators and verify that they get increasingly better
##  then verify the "equivalence" of the operator and sequence
##   - only runable from @QIASMsingle/private/
##   - will take a fair bit of time 
##   - logs data to skalgoTestData.mat

%!test
%! ## get the currently utilized U0 table
%! 
%! load("../../@QIASMcircuit/private/uzero16.mat"); 
%! addpath("../../");
%!
%! amp = (0:(pi/2/8):pi/2)'; #[0,pi/2]
%! pha = (0:(pi/8):(15*pi/8))'; #[0,2*pi)
%! ## phase/amp parameters for some SU(2) operators
%! params = [kron(amp,ones(length(pha),1)),...
%!           kron(pha,ones(length(amp),1)),...
%!           kron(ones(length(amp),1),pha)];
%!
%! save "skalgoTestData.mat" params; #write params to file
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
%! save -append "skalgoTestData.mat" etas; # write etas to file
%! ediffs = diff(etas,1,2);
%! save -append "skalgoTestData.mat" ediffs; #write diffs
%! res = ediffs <= 0; # check for monotonic decrease
%! save -append "skalgoTestData.mat" res; # write monotonic check
%! resS = find(sum(res,2)!= dep);
%! assert(length(resS)==0,"Failed on %d operators",length(resS));
%! rmpath("../../");
%! clear -g all;

    

    
