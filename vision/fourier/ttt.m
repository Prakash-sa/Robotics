clear all;

I = imresize(imread('GMARBLES.TIF'),[200 200]);


g=fftshift(fft2(I));
k=abs(g);
F=log(1+k);


[rows,cols] = size(I);
n_0 = rows*cols;
M = n_0/8;


    idx_rows = abs((1:rows) - ceil(rows/2)) < sqrt(M)/2 ; 
    idx_cols = abs((1:cols)- ceil(cols/2)) < sqrt(M)/2 ; 
    M = (double(idx_rows')) * (double(idx_cols));
    % 3) Multiply in a pointwise manner the image with the mask.  
    M=im2double(M);
    Fcomp=M.*k;

 ID=real(ifft2(ifftshift(Fcomp)));




imshow(ID,[]), colormap(jet(64)), colorbar;