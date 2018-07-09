I = imresize(imread('GMARBLES.TIF'),[200 200]);
F = fft_vis1(I);
imshow(F,[]), colormap(jet(64)), colorbar;





function [ F ] = fft_vis1(I)

    % Input:
    % I: the input image
    % Output:
    % F: 2D Fourier transform in a form amenable to visualization
    
    % Please follow the instructions in the comments to fill in the missing commands

    % 1) Apply Fourier transform to the image (MATLAB command fft2)

    % 2) Shift the spectrum (MATLAB command fftshift)

    % 3) Take the absolute value

    % 4) Add 1e-1 and take the log (for visualization)
    
    g=fft2(I);
    k=abs(fftshift(g));
    F=log(1+k);

end
