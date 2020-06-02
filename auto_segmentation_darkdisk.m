function [img2,rrr,central_object,counter_cir_hol]= auto_segmentation_darkdisk(img)

dark_I=img;
[mm,nn,~] = size(dark_I);
I = histeq(rgb2gray(img));
I = double(I);
II = nor_malize(I,1);
I = Ci_LP_Filter_dark_disk(I);
I = nor_malize(I,255);
TH = graythresh(I);
TH = TH*255;
I= double(I<TH);
I = imerode(I,strel('square',10));
I = imfill(I,'holes');
I = imdilate(I,strel('disk',10));
I = imfill(I,'holes');
I = bwareaopen(I,4000);
I = imerode(I,strel('disk',15));
I = bwareaopen(I,800);
[M,N] = size(I);
[~, numberOfBlobs] = bwlabel(I ~= 0);
if (numberOfBlobs > 0)
    [I,central_object,rrr,counter_cir_hol]= Dark_OPtic(dark_I,mm,nn);
    II = II.^2;
    I = b_vessels(II,I,M,N,central_object,rrr);
    img2= I;
end
end