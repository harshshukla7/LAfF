function  laff_copy_vector(y, x, length )
% function to include projection on positive orthant

fileID = fopen('user_laff_main.cpp','a');
if (ischar(length) == 1)
    fprintf(fileID, 'copy_vector(%s, %s, %s );\n', y, x, length);
    
elseif (isnumeric(length) == 1)
    fprintf(fileID, 'copy_vector(%s, %s, %d );\n', y, x, int32(length));
    
else
    error('length must be either character or scalar integer');
end

fclose(fileID);

end