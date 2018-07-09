clear all;
I = im2double(imresize(imread('GMARBLES.TIF'),[200 200]));
[rows,cols] = size(I);
n_0 = rows*cols;
M = n_0/8;

% Input:
    % I: the input image 
    % M_root: square root of the number of coefficients we will keep
    % Output:
    % Fcomp: the compressed version of the image

    % Please follow the instructions in the comments to fill in the missing commands.    
    
    % 1) Perform the FFT transform on the image (MATLAB command fft2).
    
    % 2) Shiftzero-frequency component to center of spectrum (MATLAB command fftshift).
   g=fft2(I);
    k=abs(fftshift(g));
    F=log(1+k);
    % We create a mask that is the same size as the image. The mask is zero everywhere, 
    % except for a square with sides of length M_root centered at the center of the image.
    [rows,cols] = size(I);
    idx_rows = abs((1:rows) - ceil(rows/2)) < sqrt(M)/2 ; 
    idx_cols = abs((1:cols)- ceil(cols/2)) < sqrt(M)/2 ; 
    M = (double(idx_rows')) * (double(idx_cols));
    % 3) Multiply in a pointwise manner the image with the mask.  
    
    Fcomp=k.*M;
    
 
imshow(F)