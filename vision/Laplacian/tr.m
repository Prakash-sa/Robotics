A = im2double(imread('apple.png'));

%%gaussian
h=fspecial('gaussian',0.5);

newimage=imfilter(B,h);
I=A-newimage;
imshow(I);