function  laff_norm_two(return_val, x, length )
% including a function to find two norm of a vector

fileID = fopen('user_laff_main.cpp','a');
if (ischar(length) == 1)
    fprintf(fileID, '%s = norm_two(%s, %s );\n', return_val, x, length);
    
elseif (isnumeric(length) == 1)
    fprintf(fileID, '%s = norm_two(%s, %d );\n', return_val, x, int32(length));
    
else
    error('length must be either character or scalar integer');
end

fclose(fileID);

end