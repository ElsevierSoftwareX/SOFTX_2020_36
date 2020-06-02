function I = b_vessels(II,I,M,N,central_object,r)

II = imbinarize(II,'adaptive','ForegroundPolarity','dark');
II = ~II;
II = bwareaopen(II,30);
II = imopen(II,strel('square',3));
II = imfill(II,'hole');
II = bwareaopen(II,400);
II = imdilate(II,strel('disk',3));
II = bwareaopen(II,1000);
II = imerode(II,strel('disk',3));
counter_cir = 0;
for i = 1:M
    for j = 1:N
        if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < r )
            II(i,j) = 0;
            counter_cir = counter_cir+1;
        end
    end
end
counter_ves = 0;
II = bwareaopen(II,50);
for i = 1:M
    for j = 1:N
        if ( II(i,j) ~= 0 )
            counter_ves = counter_ves+1;
            I(i,j,1) = 255;
            I(i,j,2) = 0;
            I(i,j,3) = 0;
        end
    end
end
end