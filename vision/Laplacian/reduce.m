function g = reduce(I)

    % Input:
    % I: the input image
    % Output:
    % g: the image after Gaussian blurring and subsampling

    % Please follow the instructions to fill in the missing commands.
    
    % 1) Create a Gaussian kernel of size 5x5 and 
    % standard deviation equal to 1 (MATLAB command fspecial)
    h=fspecial('laplacian',1);
    
    % 2) Convolve the input image with the filter kernel (MATLAB command imfilter)
    % Tip: Use the default settings of imfilter
    nI=imfilter(I,h);
    
    
    % 3) Subsample the image by a factor of 2
    % i.e., keep only 1st, 3rd, 5th, .. rows and columns
    [nr,nc]=size(nI);
    T=zeros(ceil(nr./2),ceil(nc./2));
    r=ceil(nr./2);c=ceil(nc./2);
    for i=1:r
        for j=1:c
            T(i,j)=nI(2*i-1,2*j-1);
        end
    end
    
    
    

end
