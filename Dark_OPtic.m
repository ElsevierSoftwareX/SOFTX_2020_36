function [org_I,central_object,r,counter_cir_hol] = Dark_OPtic(org_I,M,N)

im2 = zeros(M,N);
for i=1:M
    for j= 1:N
        if(org_I(i,j,1)==0 || org_I(i,j,1)==1)
            im2(i,j)=1;
        end
    end
end
I=bwareaopen(im2,5000);
hblob_radi = vision.BlobAnalysis('AreaOutputPort',true);
ar = hblob_radi(I);
r=round(sqrt(single(ar/3.14)));
hblob_center = vision.BlobAnalysis('CentroidOutputPort',true);
[~,central_object]=hblob_center(I);
counter_cir_hol = 0;
for i = 1:M
    for j = 1:N
        if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < r )
            counter_cir_hol = counter_cir_hol + 1;
        end
    end
end
end