I = imread('GMARBLES.TIF');
I = im2double(imresize(I,[200 200]));
Id = I + 0.1*rand(200);
SNR = compute_snr1(I,Id)

function snr = compute_snr1(I, Id)

    % Input:
    % I: the original image
    % Id: the approximated (noisy) image
    % Output:
    % snr: signal-to-noise ratio
    
    % Please follow the instructions in the comments to fill in the missing commands.    

    % 1) Compute the noise image (original image minus the approximation)

    % 2) Compute the Frobenius norm of the noise image
    
    % 3) Compute the Frobenius norm of the original image
    
    % 4) Compute SNR

 
    In=imnoise(I,'salt & pepper',0.1);
    [peaksnr,snr]=psnr(In,I);
    disp(peaksnr);
    
    
    
end