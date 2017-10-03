function  laff_sum_absolute(return_val, x, length )
% including a function to find absolute sum of a vector

fileID = fopen('user_laff_main.cpp','a');

if (ischar(length) == 1)
    fprintf(fileID, '%s = sum_absolute(%s, %s );\n', return_val, x, length);
    
elseif (isnumeric(length) == 1)
    fprintf(fileID, '%s = sum_absolute(%s, %d );\n', return_val, x, int32(length));
    
else
    error('length must be either character or scalar integer');
end

fclose(fileID);

end