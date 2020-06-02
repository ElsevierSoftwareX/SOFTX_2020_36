function[A,G,x_center,y_center]= macula_segmentation(deep_dataa,C,D)

[a,b]=size(deep_dataa);
A=deep_dataa-C;
G=zeros(a,b);
for i=1:a
    for j=1:b
        if (D(i,j)==1 || C (i,j)==1)
            G(i,j)=0;
        else
            G(i,j)=deep_dataa(i,j);
        end
    end
end
se3 = strel('disk',5);
m=imclose((deep_dataa),se3);
c=10;
M=zeros(a,b);
for i=1:a
    for j=1:b
        if (m(i,j)==0 && (((a/2)-c)<=i)&&(i<=((a/2)+c)) &&(((b/2)-c)<=j)&& (j<=((b/2)+c)))
            M(i,j)=0;
        else
            M(i,j)=1;
        end
    end
end
[X, Y]=find(M==0);
X1=max(X)-min(X);
x_center=round(min(X)+(X1/2));
Y1=max(Y)-min(Y);
y_center=round(min(Y)+(Y1/2));

end

