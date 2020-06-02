function org_I = Circle_Drawing(img,r,center)

    img = insertShape(img,'circle',[center(1) center(2) r],'LineWidth',3,'color','blue');
    img = insertShape(img,'circle',[center(1) center(2) r+20],'LineWidth',3,'color','blue');
    org_I = insertShape(img,'circle',[center(1) center(2) r+40],'LineWidth',3,'color','blue');
    
end