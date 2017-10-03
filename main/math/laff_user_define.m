function [] = laff_user_define( ops )
%One for loop for many operations

%TO DO: allow users to choose the directives
%TO DO: support for altera as well

fileID = fopen('user_laff_main.cpp','a');



for j=1:length(ops)
    
    fprintf(fileID, strcat( sprintf(ops{j}), '\n'));
    
end


fclose(fileID);

end

