clear all;
I=imread('bvc.jpg');
[nr,nc,nb]=size(I);
h=fspecial('laplacian',0.005);
newimage=imfilter(I,h);
sharp=I-newimage;
imshow(sharp);
