%HND_CORRESP_COORDNORM Normalise coordinates
%
% [nX1 nX2 Un Tn] = hnd_corresp_coordnorm(X1_,X2_,nm_)
%
% Normalises the correspondence points X1_ and X2_ into a more
% "compact" point cloud. Un transforms the source points to their 
% more compact space (analysis) and Tn is the same for the target
% points (synthesis). For any homography estimated between these
% more compact spaces, the homography must be "denormalised" on the
% both side.
%
% Note: This normalisation is _necessary_ for the direct linear
% transformation (DLT) based homogarphy estimation methods [1].
%
% Note: Do NOT give the homogenous coordinate if it does represent
% a "true homography coordinate", i.e. values are not constants
% (1). This normalisation automatically assumes that the values are
% constant (1) and normalises the "varying dimensions" according to
% that fact.
%
% Output:
%  nX1 - DxN (e.g. 2xN) normalised coordinates of X1_
%  nX2 - DxN (e.g. 2xN) normalised coordinates of X2_
%  Un  - Transform to normalised "analysis" space (X1)
%  Tn  - Transform to normalised "synthesis" space (X2)
%
% Input:
%  X1_    - DxN (2xN or 3xN) (inhomogenous) coordinates
%  X2_    - DxN (2xN or 3xN) (inhomogenous) coordinates
%
%  nm_    - Normalization method to be used
%           0: No normalization
%           1: The one from [1] - isotropic scaling (PREFERRED for REAL data)
%           2: The one from [1] - non-isotropic scaling (PREFERRED for ARTIFICIAL data)
%
% See also HND_CORRESP_COORDDENORM.M and H2D_CORRESP_DLT.M
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
function [nX1 nX2 Un Tn] = hnd_corresp_coordnorm(X1_,X2_,nm_)

switch (nm_)
 case 0,
  nX1 = X1_;
  nX2 = X2_;
  Un = eye(size(X1_,1),size(X1_,1)+1);
  Tn = eye(size(X1_,1),size(X1_,1)+1);
  
 case 1, % Proposed in [1], but I do not know why (pixelwise error
         % in x and y directions is the same?)
  % X1 (linear transform analysis)
  U_t = mean(X1_,2);
  U_s = diag(sqrt(2)./mean(sqrt(sum((X1_-repmat(U_t,[1 size(X1_, 2)])).^2,1))));
  %U_s = diag([U_s U_s]); % only for 2-D input
  U_s = diag(repmat(U_s,[1 size(X1_,1)]));
  Un = [U_s -U_s*U_t];
  nX1 = Un*[X1_; ones(1,size(X1_,2))];
  
  % X2 (linear transform synthesis)
  T_t = mean(X2_,2);
  T_s = diag(sqrt(2)./mean(sqrt(sum((X1_-repmat(T_t,[1 size(X1_, 2)])).^2,1))));
  % T_s = diag([T_s T_s]); % only for 2-D input
  T_s = diag(repmat(T_s,[1 size(X2_,1)]));
  Tn = [T_s -T_s*T_t];
  nX2 = Tn*[X2_; ones(1,size(X2_,2))];

 case 2, % This how it should be done according to my understanding
         % (unitwise error in x and y directions is the same)
  % X1 (linear transform analysis)
  U_t = mean(X1_,2);

  U_s = diag(1./mean(sqrt((X1_-repmat(U_t,[1 size(X1_,2)])).^2),2));
  Un = [U_s -U_s*U_t];
  nX1 = Un*[X1_; ones(1,size(X1_,2))];
  
  % X2 (linear transform synthesis)
  T_t = mean(X2_,2);

  T_s = diag(1./mean(sqrt((X2_-repmat(T_t,[1 size(X2_,2)])).^2),2));
  Tn = [T_s -T_s*T_t];
  nX2 = Tn*[X2_; ones(1,size(X2_,2))];

 otherwise,
  error('Unknown data normalisation requested!');
end;
