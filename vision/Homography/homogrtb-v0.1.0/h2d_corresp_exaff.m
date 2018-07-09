%H2D_CORRESP_EXAFF Exact 2-D homography (affinity) from point
%correspondence
%
% [H,theta,tx,ty,delta1,delta2,phi] = h2d_corresp_exaff(X1_,X2_)
%
% Computes the exact 3x3 AFFINITY transformation of 2-D points X1_
% to 2-D points X2_ in homogenous coordinates. The recovered
% transformation parameters, rotation angle theta, translations
% tx and ty, two scaling factors delta1 and delta2 and their
% scaling angle phi are also computed.
%
% Output:
%  H      - 3x3 transform matrix
%  theta  - rotation angle
%  tx     - translation X
%  ty     - translation Y
%  delta1 - scaling factor of the first scale axis (phi)
%  delta2 - scaling factor of the second scale axis (phi+90)
%  phi    - rotation angle of scale axes
%
% Input:
%  X1_    - 2xN coordinates (NOTE: Only the first 3 used)
%  X2_    - 2xN coordinates (NOTE: Only the first 3 used)
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
function [H, theta, tx, ty, delta1, delta2, phi] = ...
                                 h2d_corresp_exaff(X1_,X2_)

% Select the first two points from the both sets
x  = X1_(1:2,1:3); % origpt
xp = X2_(1:2,1:3); % transpt

% Homographic coordinates (saves also original values)
x_h = [x; ones(1,size(x,2))]; % itr
xp_h = [xp; ones(1,size(xp,2))]; % ttr

% solve transformation matrix
H = xp_h * inv(x_h);

% Resolve parameters

% A = U*D*V' = (U*V')*(V*D*V')
[U, D, V] = svd(H(1:2,1:2));

% rotation matrix
R = U * V';
% rotation matrix of the scaling
Rs = V';

theta = sign(R(2,1)) * 180 * acos(R(1,1)) / pi;
phi = sign(Rs(2,1)) * 180 * acos(Rs(1,1)) / pi;
tx = H(1,3);
ty = H(2,3);
delta1 = D(1,1);
delta2 = D(2,2);
