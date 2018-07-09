clear all;
clc;


A = im2double(imread('orange.png'));
B = im2double(imread('apple.png'));


R = zeros(512,512); R(:,257:512)=1;

gA = expand(A);
gB = reduce(B);

gR = reduce(R);

figure()
imshow(gA)
figure()
imshow(A)

function g = expand(I)

    % Input:
    % I: the input image
    % Output:
    % g: the image after the expand operation

    % Please follow the instructions to fill in the missing commands.
    
    % 1) Create the expanded image. 
    % The new image should be twice the size of the original image.
    % So, for an n x n image you will create an empty 2n x 2n image
    % Fill every second row and column with the rows and columns of the original image
    % i.e., 1st row of I -> 1st row of expanded image
    %       2nd row of I -> 3rd row of expanded image
    %       3rd row of I -> 5th row of expanded image, and so on
    
    [nr,nc,nb]=size(I);
    J=zeros(2*nr-1,2*nc-1,nb);
    for i=1:nr
        for j=1:nc
            for b=1:nb
                J(2*i-1,2*j-1,b)=I(i,j,b);
            end
        end
    end
    
    
    % 2) Create a Gaussian kernel of size 5x5 and 
    % standard deviation equal to 1 (MATLAB command fspecial)
    h=fspecial('gaussian',[5,5],1);
    
    % 3) Convolve the input image with the filter kernel (MATLAB command imfilter)
    % Tip: Use the default settings of imfilter
    % Remember to multiply the output of the filtering with a factor of 4
    
    g=4*imfilter(J,h,'conv');
    
    
    

end

function g = reduce(I)

    % Input:
    % I: the input image
    % Output:
    % g: the image after Gaussian blurring and subsampling

    % Please follow the instructions to fill in the missing commands.
    
    % 1) Create a Gaussian kernel of size 5x5 and 
    % standard deviation equal to 1 (MATLAB command fspecial)
    h=fspecial('gaussian',[5,5],1);
    
    % 2) Convolve the input image with the filter kernel (MATLAB command imfilter)
    % Tip: Use the default settings of imfilter
    nI=imfilter(I,h,'conv');
 
    
    % 3) Subsample the image by a factor of 2
    % i.e., keep only 1st, 3rd, 5th, .. rows and columns
    [nr,nc,nb]=size(nI);
    g=zeros(ceil(nr./2),ceil(nc./2),nb);
    r=ceil(nr./2);c=ceil(nc./2);
    for i=1:r
        for j=1:c
            for b=1:nb
                g(i,j,b)=nI(2*i-1,2*j-1,b);
            end
        end
    end
    
    
    

end
