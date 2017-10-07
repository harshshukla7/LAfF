function  laff_dot_vector(output, x, y, len )
% function to compute output = x'*y;
fileID = fopen('user_laff_main.cpp','a');
if (ischar(len) == 1)
    fprintf(fileID, '%s = dot_vector(%s, %s, %s );\n', output, x, y, len);
    
elseif (isnumeric(len) == 1)
    fprintf(fileID, '%s = dot_vector(%s, %s, %d );\n', output, x, y, int32(len));
    
else
    error('length must be either character or scalar integer');
end

fclose(fileID);

end