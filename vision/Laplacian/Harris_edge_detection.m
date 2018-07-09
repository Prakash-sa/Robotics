clear all;
close all;


img = imread('apple.png');
img_gray = double(rgb2gray(img));

smooth = gauss_blur(img_gray);
[I_x,I_y] = grad2d(smooth);


function [I_x,I_y] = grad2d(img)
	%% compute image gradients in the x direction
	%% convolve the image with the derivative filter from the lecture
	%% using the conv2 function and the 'same' option
	sigma = 1;
        x=-2:2;
        g = 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma^2));
        gt=g';
        
        [dx_filter,dy_filter]=gradient(gt*g);
	I_x = conv2(img,dx_filter,'same');

	%% compute image gradients in the y direction
	%% convolve the image with the derivative filter from the lecture
	%% using the conv2 function and the 'same' option

	I_y = conv2(img,dy_filter,'same');
end

function smooth = gauss_blur(img)
    %% Since the Gaussian filter is separable in x and y we can perform Gaussian smoothing by
    %% convolving the input image with a 1D Gaussian filter in the x direction then  
    %% convolving the output of this operation with the same 1D Gaussian filter in the y direction.

    %% Gaussian filter of size 5
    %% the Gaussian function is defined f(x) = 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma))
    
    sigma = 1;
     x=-2:2;
   g = 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma^2));
    gt=g';
    %% using the conv2 function and the 'same' option
    %% convolve the input image with the Gaussian filter in the x
    smooth_x = conv2(img,g,'same');
    %% convolve smooth_x with the transpose of the Gaussian filter
    smooth = conv2(smooth_x,gt,'same');
end