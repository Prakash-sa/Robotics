%H2D_CORRESP_DLT Construct 2-D homography from point
%correspondence using Direct Linear Transform
%
% [H] = h2d_corresp_dlt(X1_,X2_,dltType_)
%
% Computes a direct linear transform estimate of 3x3 transform
% transforming 2-D points X1_ to 2-D points X2_ using the point 
% correspondence. The computation can be restricted by dltType_
% parameter.
%
% Note: You should normalise the coordinates X1_ and X2_ before
% calling this function and afterwards denormalise the estimated
% homography H.
%
% Output:
%  H - 3x3 transform matrix
%
% Input:
%  X1_    - 2xN (inhomogeneous) or 3xN (homogeneous) coordinates
%  X2_    - 2xN (inhomogeneous) or 3xN (homogeneous) coordinates
%  dltType - The construction of the DLT matrices (see [1])
%            0 Full projectivity (std. DLT - Recommended)
%            1 Subset of affinity (including isometry&similarity) (DLT_r1)
%            2 Affinity (DLT_r2)
%            3 Projectivity with H(3,3) = 1 (the same as in Machine
%              vision toolbox by Peter Corke
%              (http://www.cat.csiro.au/ict/staff/pic/)) and
%              ref. [3]
%
% Note: DLT type 3 is very similar to the pseudo inverse approach
% from [4] (originally Abdel-Aziz and Karara (1971)), but adopted
% from [1] and the Camera Calibration toolbox (extinit.m) provided
% by J. Heikkila at Oulu university  (instead of the pseudo
% inverse, pinv(), the Matlab's "automatic" LSQ fit is used).
%
% See also H2D_CORRESP_COORDNORM.M
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
%  [3] Ballard, D.H., Brown, C.M., Computer Vision, (online:
%  http://homepages.inf.ed.ac.uk/rbf/BOOKS/BANDB/bandb.htm).
%
%  [4] Heikkila, J., Accurate camera calibration and feature based
%  3-D reconstruction from monocular image sequences, PhD thesis,
%  University of Oulu, 1997.
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
function [H] = h2d_corresp_dlt(X1_,X2_,dltType_)

%
% Construct homogeneous vectors if not
if (size(X1_,1) == 2)
  X1 = [X1_; ones(1,size(X1_,2))];
else
  X1 = X1_;
end;
if (size(X2_,1) == 2)
  X2 = [X2_; ones(1,size(X2_,2))];
else
  X2 = X2_;
end;

switch dltType_,
 case 0,
   %
   % Construct the linear system [1]: A_i*h = b
   A = formA(X1,X2);
   
   [U D V] = svd(A);
   H = reshape(V(:,9), [3 3])';
  
 case 1,
   %
   % Construct the linear system [1]: A_i*h = b
   [A b] = formAandb_r1(X1,X2);
   
   % solve A*h = b
   h = A\b;	% least squares solution
   H = [h(1) -h(2) h(3);
        h(2) h(1) h(4);
        0 0 1];

 case 2,
  %
  % Construct the linear system [1]: A_i*h = b
  [A b] = formAandb_r2(X1,X2);
  
  % solve A*h = b
  h = A\b;	% least squares solution
  H = [h(1) h(2) h(3);
       h(4) h(5) h(6);
       0 0 1];
  
 case 3,
  % Get the linear form
  A = formA(X1, X2);
  
  % Corresponds to fixing H(3,3)=1
  aa = A(:,1:8);
  bb = -A(:,9);
  
  C = aa \ bb;	% least squares solution
  H = reshape([C; 1]', 3, 3)';
  
 otherwise,
  error('Unknown DLT type!');
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% INTERNAL FUNCTIONS
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% FORMA Form the std SVD matrix (2-D adaptation, see [3] for
% details)
%
function [A] = formA(X1_, X2_)
numOfPoints = size(X1_, 2);

%
% Form A in [3]; Ao: odd rows Ae: even rows
% used by the approaches 1 and 2

Ao = [zeros(numOfPoints,3)...
      -(X2_(3,:).*X1_(1,:))'  ...
      -(X2_(3,:).*X1_(2,:))'  ...
      -(X2_(3,:).*X1_(3,:))'  ...
       (X2_(2,:).*X1_(1,:))'  ...
       (X2_(2,:).*X1_(2,:))'  ...
       (X2_(2,:).*X1_(3,:))'];

Ae = [(X2_(3,:).*X1_(1,:))'   ...
      (X2_(3,:).*X1_(2,:))'   ...
      (X2_(3,:).*X1_(3,:))'   ...
      zeros(numOfPoints,3)    ...
     -(X2_(1,:).*X1_(1,:))'   ...
     -(X2_(1,:).*X1_(2,:))'  ...
     -(X2_(1,:).*X1_(3,:))'];

% Form the true A
A = transpose(reshape(transpose([Ao Ae]), [9 2*numOfPoints]));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% FORMAANDB R1 Form the linear system A_i*h=b matrix (see [1] or
% [2] for details)
%
function [A,b] = formAandb_r1(X1_,X2_)
numOfPoints = size(X1_,2);

%
% Form A in [1,2] - Ao: odd rows Ae: even rows

% First 2 columns of Ao
Ao = [-(X2_(3,:).*X1_(2,:))'  ...
      -(X2_(3,:).*X1_(1,:))'  ...
      zeros(numOfPoints,1) ...
      -(X2_(3,:).*X1_(3,:))'];
Ae = [(X2_(3,:).*X1_(1,:))'   ...
      -(X2_(3,:).*X1_(2,:))'  ...
      (X2_(3,:).*X1_(3,:))'    ...
      zeros(numOfPoints,1)];

% Form the true A
A = transpose(reshape(transpose([Ao Ae]), [4 2*numOfPoints]));

%
% Form b in [1,2] - bo: odd rows be: even rows
bo = [-(X2_(2,:).*X1_(3,:))'];
be = [(X2_(1,:).*X1_(3,:))'];

% Form the true b
b = transpose(reshape(transpose([bo be]), [1 2*numOfPoints]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% FORMAANDB R2 Form the linear system A_i*h=b matrix (see [1] or
% [2] for details)
%
function [A,b] = formAandb_r2(X1_,X2_)
numOfPoints = size(X1_,2);

%
% Form A in [1,2] - Ao: odd rows Ae: even rows

Ao = [zeros(numOfPoints,3)...
      -(X2_(3,:).*X1_(1,:))'  ...
      -(X2_(3,:).*X1_(2,:))'  ...
      -(X2_(3,:).*X1_(3,:))'];

Ae = [(X2_(3,:).*X1_(1,:))'   ...
      (X2_(3,:).*X1_(2,:))'  ...
      (X2_(3,:).*X1_(3,:))'    ...
      zeros(numOfPoints,3)];

% Form the true A
A = transpose(reshape(transpose([Ao Ae]), [6 2*numOfPoints]));

%
% Form b in [1,2] - bo: odd rows be: even rows
bo = [-(X2_(2,:).*X1_(3,:))'];
be = [(X2_(1,:).*X1_(3,:))'];

% Form the true b
b = transpose(reshape(transpose([bo be]), [1 2*numOfPoints]));
