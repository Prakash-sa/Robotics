I = imread('GMARBLES.TIF');
I = im2double(imresize(I,[200 200]));
[rows,cols] = size(I);
n_0 = rows*cols;
M = n_0/8;
Fcomp = compress(I,sqrt(M));

Id = decompress1(Fcomp);

figure(2);
subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(Id);

function [Id] = decompress1(Fcomp)

    % Input:
    % F: the compressed version of the image
    % Output:
    % Id: the approximated image

    % Please follow the instructions in the comments to fill in the missing commands.    
    
    % 1) Apply the inverse FFT shift (MATLAB command ifftshift)

    % 2) Compute the inverse FFT (MATLAB command ifft2)

    % 3) Keep the real part of the previous output
    
    
    Id=real(ifft2(ifftshift(Fcomp)));

end

function [Fcomp] = compress(I,M_root)
    g=fft2(I);
    k=abs(fftshift(g));
    
    [rows,cols] = size(I);
    idx_rows = abs((1:rows) - ceil(rows/2)) < M_root/2 ; 
    idx_cols = abs((1:cols)- ceil(cols/2)) < M_root/2 ; 
    M = (double(idx_rows')) * (double(idx_cols));
    M=im2double(M);
    % 3) Multiply in a pointwise manner the image with the mask.  
    
    Fcomp=M.*k;
    % Copy this function from the previous step
end