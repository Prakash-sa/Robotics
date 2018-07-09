clear all;
clc;

% loading the image
A = im2double(imread('orange.png'));
% depth of the pyramids
depth = 5;

% we build the Gaussian pyramid
GA = gausspyramid(A,depth);

function G = gausspyramid(I,depth)

    % Input:
    % I: the input image
    % depth: number of levels of the Gaussian pyramid
    % Output:
    % G: a cell containing all the levels of the Gaussian pyramid
    
    % Please follow the instructions to fill in the missing commands.
    
    G = cell(1,depth);
    
    % 1) Create a pyramid, where the first level is the original image
    % and every subsequent level is the reduced version of the previous level
    for i = 1:depth
        if i == 1
            G{i} = I  % original image
        else
            G{i} = reduce(G{i-1});  % reduced version of the previous level
        end
    end

end

function g = reduce(I)

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
