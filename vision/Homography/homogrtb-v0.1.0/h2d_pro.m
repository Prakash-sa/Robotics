%H2D_PRO Construct 2-D homography matrix (projectivity)
%
% [H] = h2d_pro(theta_,t_,delta1_,delta2_,phi_,v1_,v2_,v)
%
% Output:
%   H - 3x3 matrix of projective transformation
%
% Input:
%  Transformation parameters (according to refs. [1-2]):
%   theta - 1x1 Rotation angle, in degrees
%       t - 2x1 Translation vector [tx ty]
%  delta1 - 1x1 scale to direction 1 (phi)
%  delta2 - 1x1 scale to direction 2 (phi+90)
%     phi - 1x1 scale angle, in degrees
%     v1  - "Elation" parameter 1 (X) [2]
%     v2  - "Elation" parameter 2 (Y) [2]
%     v   - "Elation" parameter 3 (Z) [2]
%
% See also 
%
% References:
%
%  [1] Kamarainen, J.-K., Paalanen, P., Experimental study on Fast
%  2D Homography Estimation From a Few Point Correspondence,
%  Research Report, Machine Vision and Pattern Recognition Research
%  Group, Lappeenranta University of Technology, Finland, 2008.
%
%  [2] Hartley, R., Zisserman, A., Multiple View Geometry in
%  Computer Vision, 2nd ed, Cambridge Univ. Press, 2003.
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
function [H] = h2d_pro(theta_,t_,delta1_,delta2_,phi_,v1_,v2_,v_);

% Convert to radians
theta = theta_*pi/180;
phi = phi_*pi/180;

% Rotation matrix
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
t = [t_(1) t_(2)]';

D = [delta1_ 0; 0 delta2_];
Rphi = [cos(phi) -sin(phi); sin(phi) cos(phi)];

% Final results composed of isometry part and
% non-isotropic scaling part
A = R * Rphi' * D * Rphi;
H = [[A; v1_ v2_] [t; v_]];
