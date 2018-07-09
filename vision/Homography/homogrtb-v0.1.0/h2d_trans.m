%H2D_TRANS 2-D homography transformation
%
% [Xn] = h2d_trans(X_,H_)
%
% Transform 2-D coordinates X_ using the transformation matrix H_.
%
% Output:
%  Xn - 2xN (inhomogeneous) or 3xN (homogeneous) coordinates
%
% Input:
%  X - 2xN (inhomogeneous) or 3xN (homogeneous) coordinates
%  H - 3x3 transform matrix (ref. [1])
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
function [Xn] = h2d_trans(X_, H_);

%
% Construct homogeneous vectors if not
if (size(X_,1) == 2)
  % non-homogenous (return same)
  Xn = H_*[X_; ones(1,size(X_,2))];
  Xn = Xn(1:2,:)./[ Xn(3,:); Xn(3,:) ];
else
  % homogenous (return same)
  Xn = H_*X_;
end;
