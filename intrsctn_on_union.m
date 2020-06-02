function manu = intrsctn_on_union(r,central_object,manu_I,auto_I,I_Th,counter_cir_hol)

inner_cir_R = r+20;
outer_cir_R = r+40;
[M,N,~] = size(auto_I);

counter_ves=0;
black_inner_cir=0;
black_inner_cir_up=0;
black_inner_cir_down=0;
black_outer_cir=0;
black_outer_cir_up=0;
black_outer_cir_down=0;

white_pxl=0;
W_inner_cir=0;
W_inner_cir_up=0;
W_inner_cir_down=0;
W_outer_cir=0;
W_outer_cir_up=0;
W_outer_cir_down=0;

area_inner_cir = 0;
area_outer_cir = 0;

for i = 1:M
    for j = 1:N
        if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < inner_cir_R )
            area_inner_cir  = area_inner_cir +1;
        end
        if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < outer_cir_R )
            area_outer_cir  = area_outer_cir +1;
        end
    end
end

area_inner_cir = area_inner_cir - counter_cir_hol;
area_outer_cir  = area_outer_cir - counter_cir_hol;


for i = 1:M
    for j = 1:N
        if (manu_I(i,j,1) == 255 && manu_I(i,j,2)==0)
            counter_ves = counter_ves +1;
            if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < inner_cir_R )
                black_inner_cir  = black_inner_cir +1;
                if (i<central_object(2))
                    black_inner_cir_up  = black_inner_cir_up +1;
                end
                if (i>central_object(2))
                    black_inner_cir_down  = black_inner_cir_down +1;
                end
            end
            if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < outer_cir_R )
                black_outer_cir  = black_outer_cir +1;
                if (i<central_object(2))
                    black_outer_cir_up  = black_outer_cir_up +1;
                end
                if (i>central_object(2))
                    black_outer_cir_down  = black_outer_cir_down +1;
                end
            end
        end
    end
end
for i = 1:M
    for j = 1:N
        if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) > r )
            if(I_Th(i,j) == 1)
                white_pxl = white_pxl+1;
                if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < inner_cir_R )
                    W_inner_cir = W_inner_cir+1;
                    if (i<central_object(2))
                        W_inner_cir_up=W_inner_cir_up+1;
                    end
                    if (i>central_object(2))
                        W_inner_cir_down=W_inner_cir_down+1;
                    end
                end
                if (sqrt(((i-round(central_object(2)))^2) + ((j-round(central_object(1)))^2)) < outer_cir_R )
                    W_outer_cir = W_outer_cir + 1;
                    if (i<central_object(2))
                        W_outer_cir_up = W_outer_cir_up + 1;
                    end
                    if (i>central_object(2))
                        W_outer_cir_down = W_outer_cir_down + 1;
                    end
                end
            end
        end
    end
end



manu.whole_ratio = white_pxl / (M*N - counter_ves);
manu.inner_whole_ratio = W_inner_cir/( area_inner_cir - black_inner_cir);
manu.outer_whole_ratio = W_outer_cir/ (area_outer_cir - black_outer_cir);
manu.inner_up_ratio = W_inner_cir_up/ ((area_inner_cir / 2) - black_inner_cir_up);
manu.outer_up_ratio = W_outer_cir_up/ ((area_outer_cir / 2) - black_outer_cir_up);
manu.inner_down_ratio = W_inner_cir_down/ ((area_inner_cir / 2) - black_inner_cir_down);
manu.outer_down_ratio = W_outer_cir_down/ ((area_outer_cir / 2) - black_outer_cir_down);
end