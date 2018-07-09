% load the image we will experiment with
I = imresize(double(rgb2gray(imread('lena.png'))),[256 256]);

% build the Laplacian pyramid of this image with 6 levels
depth = 6;
L = laplacianpyr(I,depth);

% compute the quantization of the Laplacian pyramid
bins = [16,32,64,128,128,256]; % number of bins for each pyramid level
LC = encoding1(L,bins);

figure()
imshow(I)
figure()
imshow(LC)



function LC = encoding1(L, bins)

    % Input:
    % L: the Laplacian pyramid of the input image
    % bins: The number of bins used for discretization of each pyramid level
    % Output:
    % LC: the quantized version of the image stored in the Laplacian pyramid
    
    % Please follow the instructions to fill in the missing commands.

    depth = numel(bins);
    LC = cell(1,depth);
    
    for i = 1:depth

        % 1) Compute the edges of the bins we will use for discretization
        % (MATLAB command: linspace)
        % For level i, the linspace command will give you a row vector 
        % with bins(i) linearly spaced points between [X1,X2].
        % Remember that the range [X1,X2] depends on the level of the 
        % pyramid. The difference images (levels 1 to depth-1) are in 
        % the range of [-128,128], while the blurred image is in the 
        % range of [0,256]
        if i == depth % blurred image in range [0, 256]
            edges = linspace(0,256);
        else % difference image in range [-128,128]
            edges = linspace(-128,128);
        end
        
        % 2) Compute the centers that correspond to the above edges
        % The 1st center -> (1st edge + 2nd edge)/2
        % The 2nd center -> (2nd edge + 3rd edge)/2 and so on
        center = zeros(1,depth-1);
        for j=1:depth-1
            center(j)=(edges(j)+edges(j+1))/2;
        end
        
        
        % 3) Discretize the values of the image at this level of the
        % pyramid according to edges (MATLAB command: discretize)
        % Hint: use 'centers' as the third argument of the discretize
        % command to get the value of each pixel instead of the bin index.
        LC{i} = discretize(L{i},bins,center);
        
    end
    
end


function L = laplacianpyr(I,depth)

    % Input:
    % I: the input image
    % depth: number of levels of the Laplacian pyramid
    % Output:
    % L: a cell containing all the levels of the Laplacian pyramid
    
    % Please follow the instructions to fill in the missing commands.
    
    L = cell(1,depth);
    
    % 1) Create a Gaussian pyramid
    % Use the function you already created.
    G=gausspyr(I,depth);

    % 2) Create a pyramid, where each level is the corresponding level of
    % the Gaussian pyramid minus the expanded version of the next level of
    % the Gaussian pyramid.
    % Remember that the last level of the Laplacian pyramid is the same as
    % the last level of the Gaussian pyramid.
    
    
    
    for i = 1:depth
        if i < depth
            L{i} = G{i} - expand(G{i+1});% same level of Gaussian pyramid minus the expanded version of next level
        else
            L{i} = G{i};% same level of Gaussian pyramid
        end
    end
    
end

function G = gausspyr(I,depth)

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
            G{i} = I ; % original image
        else
            G{i} = reduce(G{i-1});  % reduced version of the previous level
        end
    end

end

function g = reduce(I)

    % Add your code from the previous step
    
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

function g = expand(I)

    % Add your code from the previous step
    
    
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
    J=zeros(2*nr,2*nc,nb);
    for i=1:nr
        for j=1:nc
            for b=1:nb
                J(2*i,2*j,b)=I(i,j,b);
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
