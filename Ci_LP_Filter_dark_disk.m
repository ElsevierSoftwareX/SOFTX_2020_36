function img = Ci_LP_Filter_dark_disk (im_d)

im_fft = fft2(im_d);
rad_freq = 8.65;
[M,N] = size(im_d);
p = round(rad_freq*M/100);
K = ones(M,N);
for i = 1:M
    for j = 1:N
        if (sqrt(((i-M/2)^2) + ((j-N/2)^2)) < p/2 )
            K(i,j)=0;
        end
    end
end
H = ones(M,N);
for i = 1:M
    for j =1:N
        if(K(i,j)~=1)
            H(i,j)= 0;
        end
    end
end
H = ~H;
im_fs = fftshift(im_fft);
G = im_fs.*H;
img = ifft2(G);
img = abs(img);
end