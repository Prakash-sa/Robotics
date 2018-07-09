%HND_CORRESP_COORDDENORM Denormalise the transformation estimated
%using normalised coordinates
%
% [H] = hnd_corresp_coorddenorm(nH_, Un_, Tn_)
%
% Denormalises the geometric transformation (homography) matrix nH_
% (computed using normalised coordinates) to operate on the
% original data using the analysis and synthesis matrices Un and
% Tn.
%
% Output:
%  H - NxN denormalised transformation
%
% Input:
%  nH - NxN transformation for  normalised coordinates
%  Un - Transformation for analysis (X1) normalisaton
%  Tn - Transformation for synthesis (X2) normalisaton
%
% See also HND_CORRESP_COORDDENORM.M .
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
function [H] = hnd_corresp_coorddenorm(nH_, Un_, Tn_)

% Denormalize the matrix
%invTn = inv([Tn_; 0 0 1]); % only 2-D
%H = invTn*nH_*[Un_; 0 0 1]; % only 2-D
invTn = inv([Tn_; zeros(1,size(Tn_,2)-1) 1]);
H = invTn*nH_*[Un_; zeros(1,size(Un_,2)-1) 1];
