function  laff_vector_scale_add(z, y, x, len, x_scale, y_scale )
% function for z = x_scale*x + y_scale*y

if (isnumeric(x_scale))
    
    x_scale = num2str(x_scale);
    
end

if (isnumeric(y_scale))
    
    y_scale = num2str(y_scale);
    
end


if (isnumeric(len))
    
    len = num2str(len);
    
end


fileID = fopen('user_laff_main.cpp','a');

fprintf(fileID, 'vector_scale_add(%s, %s, %s, %s, %s, %s );\n', z, y, x, len, x_scale, y_scale);
    
fclose(fileID);

end