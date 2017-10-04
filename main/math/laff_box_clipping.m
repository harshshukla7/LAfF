function  laff_box_clipping(x_proj, x, len, lbl, ubl )
% function for z = x_scale*x + y_scale*y

if (isnumeric(lbl))
    
    lbl = num2str(lbl);
    
end

if (isnumeric(ubl))
    
    ubl = num2str(ubl);
    
end


if (isnumeric(len))
    
    len = num2str(len);
    
end


fileID = fopen('user_laff_main.cpp','a');

fprintf(fileID, 'box_clipping(%s, %s, %s, %s, %s);\n', x_proj, x, len, lbl, ubl);
    
fclose(fileID);

end