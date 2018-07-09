% we load the two images we will blend
A = im2double(imread('orange.png'));
B = im2double(imread('apple.png'));

% mask that defines the blending region
R = zeros(512,512); R(:,257:512)=1;

% depth of the pyramids
depth = 5;

% 1) we build the Laplacian pyramids of the two images
LA = laplacianpyr(A,depth);
LB = laplacianpyr(B,depth);

% 2) we build the Gaussian pyramid of the selected region
GR = gausspyr(R,depth); 

% 3) we combine the two pyramids using the nodes of GR as weights
[LS] = combine(LA, LB, GR);

% 4) we collapse the output pyramid to get the final blended image
Ib = collapse(LS);

% visualization of the result
imshow(Ib);


function I = collapse(L)

    % Input:
    % L: the Laplacian pyramid of an image
    % Output:
    % I: Recovered image from the Laplacian pyramid

    % Please follow the instructions to fill in the missing commands.
    
    depth = numel(L);
    
    % 1) Recover the image that is encoded in the Laplacian pyramid
    for i = depth:-1:1
        if i == depth
            % Initialization of I with the smallest scale of the pyramid
            I = 
        else
            % The updated image I is the sum of the current level of the
            % pyramid, plus the expanded version of the current image I.
            I = 
        end
    end

end

function [LS] = combine(LA, LB, GR)
    
    % Add your code from the previous step
    
end

function L = laplacianpyr(I,depth)

    % Add your code from the previous step
    
end

function G = gausspyr(I,depth)

    % Add your code from the previous step

end

