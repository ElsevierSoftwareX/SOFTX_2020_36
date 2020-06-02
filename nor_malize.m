function im_g = nor_malize (im,p)
mi_n = min(min(im));
ma_x = max(max(im));
[M,N] = size(im);
im_g = ones(M,N);
for i = 1:M
    for j = 1:N
        im_g(i,j) = ( p *(im(i,j)- mi_n )/( ma_x - mi_n));
    end
end
end