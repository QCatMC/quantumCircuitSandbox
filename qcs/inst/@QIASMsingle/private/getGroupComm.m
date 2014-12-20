## usage: [V,W] = getGroupComm(U)
##
## Compute the group commutator operators V,W such that U=VWV'W'. V
## and W are 2x2 Unitaries. Note this only works for U in SU(2) where
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

%!test
%! addpath ../../
%! for j = 1:30
%!   p = [unifrnd(0,pi,1,1),unifrnd(0,2*pi,1,2)];
%!   U = U2phaseamp(p);
%!
%!   [V,W] = getGroupComm(U);
%!   gc = V*W*(V')*(W');
%!   assert(norm(U-gc) < 2^(-30) );
%! endfor
