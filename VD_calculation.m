function [S1,S2] = VD_calculation(data,a,b,r1,c,d,r2)
figure
imshow(data);
hold on
plot(y_center,x_center,'.r')
sum=0;
d=0;
for t=a:0.01:(b)
    for  r=0:r1
        y=round(y_center+r*cos(t));
        x=round(x_center+r*sin(t));
        d=d+1;   
        plot(y,x,'.c');
        if data(x,y)==1
            sum=sum+1;
        end
    end
end
S1=sum/(d);
sum=0;
d=0;
for t=(c):0.01:(d) 
    for  r=r1:r2
        y=round(y_center+r*cos(t));
        x=round(x_center+r*sin(t));
        d=d+1;
        plot(y,x,'.c');
        if data(x,y)==1
            sum=sum+1;
        end
    end
end
S2=sum/(d);
end

