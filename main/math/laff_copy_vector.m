function  laff_copy_vector(y, x, len )
% function to copy x to y

fileID = fopen('user_laff_main.cpp','a');
if (ischar(len) == 1)
    fprintf(fileID, 'copy_vector(%s, %s, %s );\n', y, x, len);
    
elseif (isnumeric(len) == 1)
    fprintf(fileID, 'copy_vector(%s, %s, %d );\n', y, x, int32(len));
    
else
    error('length must be either character or scalar integer');
end

fclose(fileID);

end