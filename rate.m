function [Rate] = rate(img,y_center,x_center)

r1=25;
r2=76;
[m,n] = size(img);

area_in_cir1 = 0;
area_up_cir1 = 0;
area_down_cir1 = 0;

area_in_cir2 = 0;
area_down_cir2 = 0;
area_up_cir2 = 0;
area_whole = 0;

for i = 1:m
    for j = 1:n
        if ((sqrt(((i-round(y_center))^2) + ((j-round(x_center))^2))< r1) )
            area_in_cir1  = area_in_cir1 +1;
            if ((i<y_center) && img(i,j))
                area_up_cir1  = area_up_cir1 +1;
            end
            if ((i>y_center) && (img(i,j)==1))
                area_down_cir1  = area_down_cir1 +1;
            end
        end
    end
end
Rate.up_ratio_cir1=area_up_cir1/( area_in_cir1/2);
Rate.down_ratio_cir1=area_down_cir1/( area_in_cir1/2);
Rate.whole_cir2 = (area_up_cir1+ area_down_cir1) / area_in_cir2;

for i = 1:m
    for j = 1:n
        if (img(i,j))
            area_whole = area_whole+1;
        end
        if ((sqrt(((i-round(y_center))^2) + ((j-round(x_center))^2))>r1) && ...
                (sqrt(((i-round(y_center))^2) + ((j-round(x_center))^2))<r2) )
            area_in_cir2  = area_in_cir2 +1;
            
            if ((i<y_center) && (img(i,j)))
                area_down_cir2  = area_down_cir2 +1;
            end
            if ((i>y_center) && (img(i,j)==1))
                area_up_cir2  = area_up_cir2 +1;
            end
        end
    end
end
Rate.down_cir2=area_down_cir2 /( area_in_cir2/2);
Rate.up_cir2=area_up_cir2 /( area_in_cir2/2);
Rate.whole = area_whole / (m*n);
Rate. whole_cir2 = (area_up_cir2+ area_down_cir2) / area_in_cir2;

end

