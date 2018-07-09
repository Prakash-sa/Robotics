% Load the image of the sign as uint8 greyscale.
im = rgb2gray(imread('target_3.png'));

% Compute the image histogram as a 256x1-element
% vector using the ihist() function and store the
% result in the variable H. 
H = imhist(im);

% Determine the grey level which occurs most often
% in the image and store that in the variable M.
M = 80;

% Visually inspect the image histogram given above
% and determine a suitable threshold and store it
% in the variable T. 
T =175;

% Compute the logical binary image corresponding to
% this threshold and store it in the variable imThresh. 
imThresh = im>T;

% Display the thresholded image;
figure; imshow(imThresh);
imshow(H);
