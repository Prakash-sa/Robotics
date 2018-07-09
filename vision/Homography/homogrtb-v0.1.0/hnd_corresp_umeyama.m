%HOMOGR_ND_CORRESP_UMEYAMA Estimate similarity transform in n-D
%
% [H t rot s] = homogr_nd_corresp_umeyama(X1_, X2_, scale_)
%
% Computes an estimate of a similarity transform between given
% point correspondences in D-dimensional Euclidean space, minimizing
% geometric forward projection error.
%
% Output:
%  H   - D+1 x D+1 transform matrix
%  t   - translation vector (optional)
%  rot - rotation matrix (optional)
%  s   - scale (optional)
%
% Input:
%  X1_    - DxN inhomogeneous coordinates
%  X2_    - DxN inhomogeneous coordinates
%  scale_ - scalar, forced scale of the transformation.
%
% Use 0 as scale_ to let the Umeyama method estimate the scale in the
% transformation. Any other value forces the scale factor to be the given
% value. To estimate on isometry, use scale_ = 1.
%
% References:
%
% [1] Shinji Umeyama. Least-Squares Estimation of Transformation Parameters
%     Between Two Point Patterns. PAMI, vol. 13, no. 4, April 1991.
%
% Author(s):
%    Joni Kamarainen <Joni.Kamarainen@lut.fi>
%    Pekka Paalanen <Pekka.Paalanen@lut.fi>
%
% Copyright:
%
%   Homography estimation toolbox is Copyright (C) 2008 by Joni-Kristian
%   Kamarainen.
%
%   $Name:  $ $Revision: 1.1 $  $Date: 2008-05-07 12:22:15 $
%
%%
function [H, varargout] = hnd_corresp_umeyama(X1_, X2_, scale_)

[Dim N] = size(X1_);

mu1 = mean(X1_, 2);
mu2 = mean(X2_, 2);

% covariance
C1 = X1_ - repmat(mu1, 1, N);
C2 = X2_ - repmat(mu2, 1, N);
Sigma = 1/N * (C2 * C1');

[U D V] = svd(Sigma);
S = eye(Dim);

detprod = det(U) * det(V);
if detprod < 0
	S(Dim,Dim) = -1;
end

% rotation matrix
R = U * S * V';

% scale
if scale_ == 0
	s = N / sum(C1(:).^2) * trace(D*S);
else
	s = scale_;
end

% translation
t = mu2 - s * R * mu1;

% transformation matrix
H = [ [s*R; zeros(1,Dim)] [t; 1] ];

outr = { t, R, s };
for i = 1:length(outr)
	if nargout > i+1
		varargout{i} = outr{i};
	end
end
