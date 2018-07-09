%H2D_ISO Construct 2-D homography matrix restricted to 
%(orientation preserving) isometry transformation
%
% [H_E] = h2d_iso(theta_,t_)
%
%
% Output:
%   H_E - 3x3 matrix of isometry transformation
%
% Input:
%  Transformation parameters (according to ref. [1]):
%   theta - 1x1 Rotation angle, in degrees
%       t - 2x1 Translation vector [tx ty]
%
% See also 
%
% References:
%
%  [1] Hartley, R., Zisserman, A., Multiple View Geometry in
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
function [H_E] = h2d_iso(theta_,t_);

% Convert to radians
theta = theta_*pi/180;

% Rotation matrix
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
t = [t_(1) t_(2)]';
H_E = [ [R; 0 0] [t; 1]];
