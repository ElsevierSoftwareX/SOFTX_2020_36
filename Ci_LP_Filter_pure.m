function img = Ci_LP_Filter_pure (im_d)

im_fft = fft2(im_d);
rad_freq =8.65;
[M,N] = size(im_d);
p = round(rad_freq*M/100);
pic = ones(M,N);
shapeInserter = vision.ShapeInserter('Shape','Circles','Fill',1);
circles=int32([N/2 M/2 p/2]);
K=shapeInserter(pic,circles);
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