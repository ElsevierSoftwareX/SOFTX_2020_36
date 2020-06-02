function [img2,r,central_object,counter_cir_hol]= auto_segmentation_pure(img)

img2=img;
dark_I = img;
I = histeq(rgb2gray(img));
I = im2double(I);
II = nor_malize(I,1);
I = Ci_LP_Filter_pure(I);
I = nor_malize(I,255);
I = double(I<123);
SE1 = strel('square',10);
SE2= strel('disk',10);
I = imerode(I,SE1);
I = imclearborder(I);
I = imfill(I,'holes');
I = imdilate(I,SE2);
I = imfill(I,'holes');
I = bwareaopen(I,4000);
I = imerode(I,strel('disk',15));
I = bwareaopen(I,800);
[M,N] = size(I);
[labeledImage, numberOfBlobs] = bwlabel(I ~= 0);
measurements = regionprops(labeledImage, 'Centroid');
allCentroids = [measurements.Centroid];
xCentroids = allCentroids(1:2:end);
yCentroids = allCentroids(2:2:end);
if (numberOfBlobs >0)
    for i = 1 : numberOfBlobs
        dis_x = abs(xCentroids(i) - M/2);
        dis_y = abs(yCentroids(i) - N/2);
        dis(i) = round(sqrt(dis_x^2 + dis_y^2));
    end
    [~,index] = min(dis);
    for i = 1:M
        for j = 1:N
            if (labeledImage(i,j) ~= index)
                I(i,j)=0;
            end
        end
    end
    central_object =[xCentroids(index), yCentroids(index)];
    I(round(central_object(1)),round(central_object(2))) = 0;
    hblob_newer = vision.BlobAnalysis('AreaOutputPort',true);
    ar = hblob_newer(I);
    r=round(sqrt(single(ar/3.14)))+10;
    counter_cir_hol = 0;
    for i = 1:M
        for j = 1:N
            if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < r )
                counter_cir_hol = counter_cir_hol + 1;
                dark_I(i,j,1)=0;
                dark_I(i,j,2)=0;
                dark_I(i,j,3)=0;
            end
        end
    end
    for i=1:M
        for j=1:N
            II(i,j)=II(i,j)^2;
        end
    end
    I = b_vessels(II,dark_I,M,N,central_object,r);
    for i = 1:M
        for j = 1:N
            if ( I(i,j,1) == 255 )
                img(i,j,1) = 255;
                img(i,j,2) = 0;
                img(i,j,3) = 0;
            end
        end
    end
    img2= img;
end
end
