function [] = laff_for_loops( ops , loop_length )
%One for loop for many operations

%TO DO: allow users to choose the directives
%TO DO: support for altera as well

fileID = fopen('user_laff_main.cpp','a');


fprintf(fileID, 'for(i=0; i<%d; i++){ \n', loop_length);
fprintf(fileID, '#pragma HLS PIPELINE \n');

for j=1:length(ops)
    
    fprintf(fileID, strcat('\t', sprintf(ops{j}), '\n'));
    
end

fprintf(fileID, '}');

fclose(fileID);

end

