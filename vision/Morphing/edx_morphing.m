clc;
clear all;
warp_frac=0.5;

% ream images
I = im2double(imread('a.png'));
J = im2double(imread('c.png'));

% load mat file with points, variables Ip,Jp
 load('points.mat');
 
% initialize ouput image (morphed)
M = zeros(size(I));

%  Triangulation (on the mean shape)
MeanShape = (1/2)*Ip+(1/2)*Jp;
TRI = delaunay(MeanShape(:,1),MeanShape(:,2));


% number of triangles
TriangleNum = size(TRI,1); 

% find coordinates in images I and J
CordInI = zeros(3,3,TriangleNum);
CordInJ = zeros(3,3,TriangleNum);

for i =1:TriangleNum
  for j=1:3
    
    CordInI(:,j,i) = [ Ip(TRI(i,j),:)'; 1];
    CordInJ(:,j,i) = [ Jp(TRI(i,j),:)'; 1]; 
    
  end 
end

% create new intermediate shape according to warp_frac
Mp = (1-warp_frac)*Ip+warp_frac*Jp; 

 
% create a grid for the morphed image
[x,y] = meshgrid(1:size(M,2),1:size(M,1));

% for each element of the grid of the morphed image, find  which triangle it falls in
TM = tsearchn([Mp(:,1) Mp(:,2)],TRI,[x(:) y(:)]);



morphed=morph(I,J,Ip,Jp,TRI,0.5,0.5);

figure()
imshow(morphed)
%figure(100);
%subplot(1,3,1);
%imshow(I);
%hold on;
%triplot(TRI,Ip(:,1),Ip(:,2))
%hold off;
%title('First')

%subplot(1,3,2);
%imshow(M);
%hold on;
%triplot(TRI,Jp(:,1),Jp(:,2))
%hold off
%title('Morphed')

%subplot(1,3,3);
%imshow(J);
%hold on;
%triplot(TRI,Jp(:,1),Jp(:,2))
%hold off
%title('Second')
