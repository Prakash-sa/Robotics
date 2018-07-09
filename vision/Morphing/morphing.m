clc
close all

% Providing the Source(im1) and Destination(im2) Images.
im1=imread('a.png');
im2=imread('c.png');

% Resizing the images if necessary(Both the images should be equal in size) 
%im2=imresize(im2,[size(im1,1) size(im1,2)]);



im3=mesh_based_warping(im1,im2,100,0.5);

figure()
imshow(im3)