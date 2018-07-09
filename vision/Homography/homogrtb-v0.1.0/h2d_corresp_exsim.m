%H2D_CORRESP_EXSIM Exact 2-D homography (similarity) from point
%correspondence
%
% [H,theta,tx,ty,s] = h2d_corresp_exsim(X1_,X2_)
%
% Computes the exact 3x3 SIMILARITY transformation of 2-D points X1_
% to 2-D points X2_ in homogenous coordinates. The recovered
% transformation parameters, rotation angle theta, translations
% tx and ty, and the isotropic scale s are also computed.
%
% Output:
%  H     - 3x3 transform matrix
%  theta - rotation angle
%  tx    - translation X
%  ty    - translation Y
%  s     - isotropic scale
%
% Input:
%  X1_    - 2xN coordinates (NOTE: Only the first 2 used)
%  X2_    - 2xN coordinates (NOTE: Only the first 2 used)
%
% See also H2D_CORRESP.M
%
% References:
%
%  [1] Kamarainen, J.-K., Paalanen, P., Experimental study on Fast
%  2D Homography Estimation From a Few Point Correspondence,
%  Research Report, Machine Vision and Pattern Recognition Research
%  Group, Lappeenranta University of Technology, Finland, 2008.
%
% Author(s):
%    Joni Kamarainen <Joni.Kamarainen@lut.fi>
%
% Copyright:
%
%   Homography estimation toolbox is Copyright (C) 2008 by Joni-Kristian
%   Kamarainen.
%
%   $Name:  $ $Revision: 1.1 $  $Date: 2008-05-07 12:22:15 $
%
%%
function [H,theta,tx,ty,s] = h2d_corresp_exsim(X1_,X2_)

% Select the first two points from the both sets
x  = X1_(1:2,1:2); % origpt
xp = X2_(1:2,1:2); % transpt

% Homographic coordinates (saves also original values)
x_h = [x; ones(1,size(x,2))]; % itr
xp_h = [xp; ones(1,size(xp,2))]; % ttr

% Take first as pivot coodinate
x_2 = x(:,2) - x(:,1); % p1
r = sqrt(sum(x_2.^2)); % r1
xp_2 = xp(:,2) - xp(:,1); %p2
rp = sqrt(sum(xp_2.^2)); % r2

% Translation matrix for reseting pivot
A_o = [ 1 0 -x_h(1,1); 0 1 -x_h(2,1); 0 0 1 ]; % invA

% Rotation matrix for rotating points
R_thetahat = [ xp_2(1)  xp_2(2);...
               xp_2(2) -xp_2(1) ] * ...
    [ x_2(1)  x_2(2); ...
      x_2(2) -x_2(1) ] ./ ...
    ( r * rp );

% saturate numerical inaccuracies
R_thetahat = max(min(R_thetahat, 1), -1);

% Isotropic scale defined by the distance ratio
S = [ rp/r 0 0; 0 rp/r 0; 0 0 1 ];

% Translation of pivot to pivot location B
A_B = [ 1 0 xp_h(1,1); 0 1 xp_h(2,1); 0 0 1 ]; % Ap

% Complete isometry transformation 
H = A_B*S*[R_thetahat [0; 0]; 0 0 1]*A_o;
%T =  Ap * S * [ R [0; 0]; 0 0 1 ] * invA;

% Resolve parameters
%theta = 180*asin(R_thetahat(2,1))/pi;
theta = sign(R_thetahat(2,1))*180*acos(R_thetahat(1,1))/pi;
tx = H(1,3);
ty = H(2,3);
s = S(1,1);
