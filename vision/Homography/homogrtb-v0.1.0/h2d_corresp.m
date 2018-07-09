%H2D_CORRESP Estimate 2-D homography between point correspondence
%
% [H] = h2d_corresp(X1_,X2_,:)
%
% Computes an estimate of 3x3 geometric transformation (homography)
% from 2-D points X1_ to 2-D points X2_ .
%
%
% Output:
%  H - 3x3 transform matrix
%
% Input:
%  X1_    - 2xN (inhomogeneous) or 3xN (homogeneous) coordinates
%  X2_    - 2xN (inhomogeneous) or 3xN (homogeneous) coordinates
%
%  <optional>
% 'hType'     - Homography type (see [1] or [2]):
%               'projectivity' (DEFAULT)
%               'affinity'
%               'similarity'
%               'isometry'
%
% 'estMethod' - Related to the selected homography (different
%               options given in the order of preference, see [1])
%               hType = 'projectivity':
%                 'dlt' (DEFAULT) / 'dlt_r3'
%               hType = 'affinity'
%                 'dlt_r2' (DEFAULT)/ 'ransam_affinity' /
%                 'exact_affinity'
%               hType = 'similarity'
%                 'umeyama' (DEFAULT)/ 'ransam_similarity' /
%                 'exact_similarity' / 'dlt_r1' (not recommended
%                 since strict similarity not proven)
%               hType = 'isometry'
%                 'umeyama-iso' (DEFAULT) / 'ransam_isometry' /
%                 'exact_isometry'
%
%               NOTE: Different estimation methods (especially
%               'ransam_*' may require further parameters and these
%               are passed to the functions as:
%                 'ransam_iters' (DEFAULT = 100)
%                 'dlt_normMeth' (DEFAULT = 1) 
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
%%
function [H] = h2d_corresp(X1_,X2_,varargin)

% Parse input arguments
conf = struct('hType','projectivity','estMethod','DEFAULT',...
              'ransam_iters', 100, 'dlt_normMeth',1);
conf = getargs(conf,varargin);

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

%
% Call proper estimation function
switch conf.hType
  % ISOMETRY estimation methods
 case 'isometry',
  switch conf.estMethod,
   case {'DEFAULT','umeyama-iso'},
    H = hnd_corresp_umeyama(X1(1:2,:), X2(1:2,:), 1);
   case 'ransam_isometry',
    H = h2d_corresp_ransam(X1, X2, 1, conf.ransam_iters, 1);
   case 'exact_isometry',
    H = h2d_corresp_exiso(X1(1:2,:), X2(1:2,:));
   otherwise,
    error(['Not supported estimation method for the homography of ' ...
           'type ' conf.hType]);
  end;
 
  % SIMILARITY estimation methods
 case 'similarity',
  switch conf.estMethod,
   case {'DEFAULT','umeyama'},
    H = hnd_corresp_umeyama(X1(1:2,:), X2(1:2,:), 0);
   case 'ransam_similarity',
    H = h2d_corresp_ransam(X1, X2, 2, conf.ransam_iters, 1);
   case 'exact_similarity',
    H = h2d_corresp_exsim(X1(1:2,:), X2(1:2,:));
   case 'dlt_r1',
    [nX1 nX2 Un Tn] = hnd_corresp_coordnorm(X1(1:2,:),X2(1:2,:),conf.dlt_normMeth);
    nX1 = [nX1; X1(3,:)];
    nX2 = [nX2; X2(3,:)];
    nH = h2d_corresp_dlt(nX1, nX2,1);
    H = hnd_corresp_coorddenorm(nH, Un, Tn);
   otherwise,
    error(['Not supported estimation method for the homography of ' ...
           'type ' conf.hType]);
  end;

  % AFFINITY estimation methods
 case 'affinity',
  switch conf.estMethod,
   case {'DEFAULT','dlt_r2'},
    [nX1 nX2 Un Tn] = hnd_corresp_coordnorm(X1(1:2,:),X2(1:2,:),conf.dlt_normMeth);
    nX1 = [nX1; X1(3,:)];
    nX2 = [nX2; X2(3,:)];
    nH = h2d_corresp_dlt(nX1,nX2,2);
    H = hnd_corresp_coorddenorm(nH, Un, Tn);
   case 'ransam_affinity',
    H = h2d_corresp_ransam(X1, X2, 3, conf.ransam_iters, 1);
   case 'exact_affinity',
    H = h2d_corresp_exaff(X1(1:2,:), X2(1:2,:));
   otherwise,
    error(['Not supported estimation method for the homography of ' ...
           'type ' conf.hType]);
  end;

  % PROJECTIVITY estimation methods
 case 'projectivity',
  switch conf.estMethod,
   case {'DEFAULT','dlt'},
    [nX1 nX2 Un Tn] = hnd_corresp_coordnorm(X1(1:2,:),X2(1:2,:),conf.dlt_normMeth);
    nX1 = [nX1; X1(3,:)];
    nX2 = [nX2; X2(3,:)];
    nH = h2d_corresp_dlt(nX1,nX2,0);
    H = hnd_corresp_coorddenorm(nH, Un, Tn);
   case 'dlt_r3',
    [nX1 nX2 Un Tn] = hnd_corresp_coordnorm(X1(1:2,:),X2(1:2,:),conf.dlt_normMeth);
    nX1 = [nX1; X1(3,:)];
    nX2 = [nX2; X2(3,:)];
    nH = h2d_corresp_dlt(nX1,nX2,3);
    H = hnd_corresp_coorddenorm(nH, Un, Tn);
   otherwise,
    error(['Not supported estimation method for the homography of ' ...
           'type ' conf.hType]);
  end;

 otherwise,
  error(['Unkown homography: ' conf.hType]);
end;