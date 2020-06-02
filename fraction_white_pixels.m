function [sum] = fraction_white_pixels( img )

[M,N]=size(img);
area_whole=0;
area_up=0;
area_down=0;

for i=1:M
    for j=1:N
        if ( img(i,j)==1 )
            area_whole=area_whole+1;
        end
        if (i<(M/2) && img(i,j)==1 )
            area_up=area_up+1;
        end
        if (i>(M/2) && img(i,j)==1)
            area_down=area_down+1;
        end
    end
end
sum.whole=area_whole/(M*N);
sum.up=area_up/(N*(M/2));
sum.down=area_down/(N*(M/2));
end

