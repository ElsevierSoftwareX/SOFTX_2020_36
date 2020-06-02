function I = manual_segmentation(img)
I = img;
flag=0;
counter_1 = 100;
[M,N]=size(img);
I1 = zeros(M,N);
while (counter_1>1)
    test = imfreehand('close','0');
    pos = test.getPosition();
    for i = 1:length(pos)
        I1(round(pos(i,2)),round(pos(i,1)),1) = 1;
    end
    choice = questdlg('Do you want to detect more vessels?');
    switch choice
        case 'No'
            break;
        case 'Cancel'
            flag=1;
            break;
    end
end

if(flag == 0)
    I1 = bwmorph(I1,'thicken',2);
    I1 = bwmorph(I1,'bridge');
    I1 = imdilate(I1, strel('disk',1));
    for i = 1:M
        for j = 1:N
            if(I1(i,j) == 1)
                I(i,j,1) = 255;
                I(i,j,2) = 0;
                I(i,j,3) = 0;
            end
        end
    end
    
else
    I=img;
end
end
