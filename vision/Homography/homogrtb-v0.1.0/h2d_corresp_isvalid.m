%H2D_CORRESP_ISVALID Checks if the given point set is valid
%for estimating the specific homography
%
% [v] = h2d_corresp_isvalid(X1_,X2_,h_,:)
%
% Returns v == 1 if the point configurations in X1 and X2 are valid
% for estimating the homography type h_.
%
% NOTE: This functions is _experimental_ and mainly needed by
% H2D_CORRESP_RANSAM.M since it would collapse if the underlying
% exact method collapses. It would be wise to explore [2] and
% implement this function using some decent theory - now it can be
% used only to check point configuration before any exact
% estimation method!
%
% NOTE: Can be extended to cover arbitratry many points, but that
% may take a lot of time (all combinations must be checked)!!
%
% Output:
%  v - 1x1 1 if valid, 0 if not
%
% Input:
%  X1_    - 2xN coordinates
%  X2_    - 2xN coordinates
%  ht_    - Homography type
%	1   : isometry
%	2   : similarity
%	2.5 : similarity+
%           varargin(1) : scale angle alpha [1]
%           varargin(2) : estimation direction (1: from model, 2:to
%                         model) [1]
%
% See also HOMOGR_2D_CORRESP_EXACT_*.M
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
function [v] = h2d_corresp_isvalid(X1_,X2_,h_)

v = 1;
numTol = 10^3*eps; % Numerical stability tolerance

% Set min required number of points
switch h_
 case 0,
  minPoints = 0;
 case 1,
  minPoints = 2;
 case 2,
  minPoints = 2;
 case 2.5,
  minPoints = 3;
 otherwise,
  error(['Unknown homography type h_=' num2str(h_)]);
end;

%
% All homographies - general restriction on numerical stability
if (h_ >= 0)
  % No estimation is numerically stable if all points are too close
  % to each other (practically no transformation needed at all)
  if (max(sum((X1_-X2_).^2,1)) < numTol) 
    v = 0;
  end;
end;
  
%
% Isometry and above
if (h_ >= 1)
  % Case 1
  % Some estimation point pair in either set are the same points
  % nchoosek(minPoints,2) diff combinations
  for pivotInd = 1:minPoints-1
    for pointInd = pivotInd+1:minPoints
      if ((sum((X1_(:,pivotInd)-X1_(:,pointInd)).^2,1) < numTol) |...
          (sum((X1_(:,pivotInd)-X1_(:,pointInd)).^2,1) < numTol))
        v = 0;
      end;
    end;
  end;
end;

%
% Isometry and similarity have the same restrictions

%
% Similarity+ and above
if (h_ >= 2.5)
  % Case 2
  % Some 3 points lay on the same line
  % nchoosek(minPoints,3) diff combinations (includes Case 1) 
  for pivotInd = 1:minPoints-2
    for pivotInd2 = pivotInd+1:minPoints-1
      pivotLine = cross([X1_(:,pivotInd); 1],[X1_(:,pivotInd2); 1]);
      for poinInd = pivotInd2+1:minPoints
        if (([X1_(:,pointInd)' 1]*pivotLine)^2 < numTol)
          v = 0;
        end;
      end;
    end;
  end;
end;
