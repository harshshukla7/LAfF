function  laff_proj_positve(x_proj, x, length )
% function to include projection on positive orthant

fileID = fopen('user_laff_main.cpp','a');
if (ischar(length) == 1)
    fprintf(fileID, 'proj_positive(%s, %s, %s );\n', x_proj, x, length);
    
elseif (isnumeric(length) == 1)
    fprintf(fileID, 'proj_positive(%s, %s, %d );\n', x_proj, x, int32(length));
    
else
    error('length must be either character or scalar integer');
end

fclose(fileID);

end

