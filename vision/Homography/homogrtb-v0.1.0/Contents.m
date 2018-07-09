% HomoGr Toolbox - Homography estimation
% Version 0.1
%
% Main interface
%   h2d_corresp         - Estimate 2-D homography between point
%                         correspondence 
%
% Parameterised transforms
%   h2d_iso             - Construct 2-D homography matrix
%                         restricted to (orientation preserving)
%                         isometry transformation 
%   h2d_sim             - Construct 2-D homography matrix
%                         restricted to (orientation preserving)
%                         similarity transformation 
%   h2d_aff             - Construct 2-D homography matrix
%                         restricted to affinity transformation
%   h2d_prj             - Construct 2-D homography matrix
%                         (projectivity) 
%   h2d_trans           - 2-D homography transformation
%
% Implemented estimation methods (called from main interface)
%   h2d_corresp_exiso   - Exact 2-D homography (isometry) from
%                         point correspondence
%   h2d_corresp_exsim   - Exact 2-D homography (similarity) from
%                         point correspondence
%   h2d_corresp_exaff   - Exact 2-D homography (affinity) from
%                         point correspondence
%   h2d_corresp_ransam  - Exact 2-D homography (any) from point 
%                         correspondence (best transformation
%                         selected by random sampling) 
%   hnd_corresp_umeyama - Estimate similarity transform in n-D
%   h2d_corresp_dlt     - Construct 2-D homography from point
%                         correspondence using Direct Linear
%                         Transform 
%
% Supporting functions for the estimation methods
%   h2d_corresp_isvalid     - Checks if the given point set is
%                             valid for estimating the specific
%                             homography
%   hnd_corresp_coorddenorm - Denormalise the transformation
%                             estimated using normalised
%                             coordinates
%   hnd_corresp_coordnorm   - Normalise coordinates
%
% General functions
%   h2d_version             - Return version string.
%   getargs                 - Parse variable argument list into a struct.
%
% Demos
%   h2d_demo01              - A simple homography demo
%
% References:
%    See the function helps for references
%
% Authors:
%    Joni Kamarainen <Joni.Kamarainen@lut.fi>
%
% Acknowledgements:
%
% Copyright:
%
%   Homography estimation toolbox is Copyright (C) 2008 by Joni-Kristian
%   Kamarainen.
%
%   The software package is free software; you can redistribute it
%   and/or modify it under terms of GNU General Public License as
%   published by the Free Software Foundation; either version 2 of
%   the license, or any later version. For more details see licenses
%   at http://www.gnu.org
%
%   The software package is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%   See the GNU General Public License for more details.
%
%   As stated in the GNU General Public License it is not possible to
%   include this software library or even parts of it in a proprietary
%   program without written permission from the owners of the copyright.
%   If you wish to obtain such permission, you can reach us by mail:
%
%      Department of Information Processing
%      Lappeenranta University of Technology
%      P.O. Box 20 FIN-53851 Lappeenranta
%      FINLAND
%
%  and by e-mail:
%      
%      joni.kamarainen@lut.fi
%
%  Please, if you find any bugs contact authors.
%
%  Project home page: http://www.it.lut.fi/project/homogr/
%
%   $Name:  $ $Revision: 1.1 $  $Date: 2008-05-07 12:22:14 $
%
