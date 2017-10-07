function  laff_vector_min(z, y, x, len )
% function to copy x to y

fileID = fopen('user_laff_main.cpp','a');
if (ischar(len) == 1)
    fprintf(fileID, 'vector_min(%s, %s, %s, %s );\n', z, y, x, len);
    
elseif (isnumeric(len) == 1)
    fprintf(fileID, 'vector_min(%s, %s, %s, %d );\n', z, y, x, int32(len));
    
else
    error('length must be either character or scalar integer');
end

fclose(fileID);

end