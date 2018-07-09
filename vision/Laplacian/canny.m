clear all;
clc;
I=im2double(imread('apple.png'));
edg=edge(rgb2gray(I),'canny',0.2);

figure()
imshow(edg)