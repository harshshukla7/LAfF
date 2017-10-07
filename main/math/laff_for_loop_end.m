function  laff_for_loop_end()
% function to end for loop. must be used with laff_for_loop_begin


fileID = fopen('user_laff_main.cpp','a');

fprintf(fileID, '} \n \n \n');
    
fclose(fileID);

end