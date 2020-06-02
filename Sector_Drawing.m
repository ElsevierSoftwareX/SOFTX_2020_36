function I=Sector_Drawing(str,I,x_center, y_center)

[M,~,~]=size(I);
M = floor(M);
c_Unit = M/12;
switch str
    case 7
        I = insertShape(I,'circle',[x_center y_center c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 3*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 5*c_Unit],'LineWidth',2,'color','green');
    case 6
        I = insertShape(I,'circle',[x_center y_center 2*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 4*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 6*c_Unit],'LineWidth',2,'color','green');
    case 5
        I = insertShape(I,'circle',[x_center y_center 3*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 5*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 7*c_Unit],'LineWidth',2,'color','green');
    case 4
        
        I = insertShape(I,'circle',[x_center y_center 4*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 6*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 8*c_Unit],'LineWidth',2,'color','green');
        
    case 3
        
        I = insertShape(I,'circle',[x_center y_center 5*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 7*c_Unit],'LineWidth',2,'color','green');
        I = insertShape(I,'circle',[x_center y_center 9*c_Unit],'LineWidth',2,'color','green');
end

end

