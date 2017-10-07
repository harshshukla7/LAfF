function  laff_for_loop_begin(number_of_iterations, loop_name )
% funtion that implements for loop. must be used with laff_for_loop_end
% number of iterations: can be a number or character
% loop_name: must be character

if (ischar(loop_name) == 0)
    error('loop name must be a character and different than any declared variable names and any other loop names');
end
  

if (isnumeric(number_of_iterations))
    number_of_iterations = num2str(number_of_iterations);
end



fileID = fopen('user_laff_main.cpp','a');


fprintf(fileID, 'int %s_counter;\n', loop_name);
fprintf(fileID, '%s: for(%s_counter = 0; %s_counter < %s; %s_counter++){ \n \n', loop_name, loop_name, loop_name, number_of_iterations, loop_name);
fprintf(fileID, '#pragma HLS PIPELINE \n');
   
fclose(fileID);

end