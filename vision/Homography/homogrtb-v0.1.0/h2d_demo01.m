%H2D_DEMO01 Demo script for HomoGr ToolBox functions
%
% [] = h2d_demo01
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
srcP = unifrnd(-1,1,2,10);

plot(srcP(1,:),srcP(2,:),'rx','MarkerSize',15,'LineWidth',2);
input('Source points <RETURN>');

H = h2d_aff(40,[1 2],1,2,15)

trgP = h2d_trans(srcP,H);
ntrgP = trgP+normrnd(0,0.05,size(trgP));
plot(trgP(1,:),trgP(2,:),'gx',...
     ntrgP(1,:),ntrgP(2,:),'bx',...
     'MarkerSize',15,'LineWidth',2);
legend('original','noisy');
input('Correct and noisy target points for homography H <RETURN>');

Hest = h2d_corresp(srcP,ntrgP,'hType','affinity')

trgPest = h2d_trans(srcP,Hest);
hold on;
plot(trgPest(1,:),trgPest(2,:),'ko','MarkerSize',15,'LineWidth',2);
hold off;
input('Target points and estimated points by Hest <RETURN>');
