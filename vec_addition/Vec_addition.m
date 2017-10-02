function output = Vec_addition(length_vec, settings)

%% Question to be discussed:
%%% option 1: What do we assume,shall we write just another m file to save all the data and here we only do abtract code generation 
%%% option 2: we also pass the vector values or at least keep that as an
%%% optional setting and save the data from here. From the user point of
%%% view I think this option is much better
%% Mandatory input arguments:
% 1. settings
%  Optional input arguments
% 1. 'matrix_name': Name of the matrix
% 2. 'input_vector': value of input vector
% 3. 'input_vector_name': name of the input vector
% 4. 'output_vector_name': name of the output vector
% 5. 'adder_latency': 
% 6. 'data_type': float or fixed
% 7. 'interg_bits': number of integer bits
% 8. 'frac_bits': number of fraction bits
% 9. 'func_file_c': File name given by user
%10. 'func_file_h': File name given by user
%11. 'data_file_h': File name given by user


default_input_vector_name1 = 'x';
default_input_vector_name2 = 'y';
default_output_vector_name = 'z';
default_data_type = 'float';
default_adder_latency = 8;
default_func_file_c = 'user_function.c';
default_func_file_h = 'user_function.h';
default_data_file_h = 'user_data.h';




if( isnumeric(length_vec) == 0  || isscalar(length_vec) == 0)
    
    error('Vector length should be scalar and numeric')

end



if ~isfield(settings, 'input_vector1'), settings.input_vector1 = rand(length_vec,1); end
if ~isfield(settings, 'input_vector2'), settings.input_vector2 = rand(length_vec,1); end
if ~isfield(settings, 'input_vector_name1'), settings.input_vector_name1 = default_input_vector_name1; end
if ~isfield(settings, 'input_vector_name2'), settings.input_vector_name2 = default_input_vector_name2; end
if ~isfield(settings, 'output_vector_name'), settings.output_vector_name = default_output_vector_name; end
if ~isfield(settings, 'data_type'), settings.data_type = default_data_type; end
if ~isfield(settings, 'adder_latency'), settings.adder_latency = default_adder_latency; end
if ~isfield(settings, 'func_file_c'), settings.func_file_c = default_func_file_c; end
if ~isfield(settings, 'func_file_h'), settings.func_file_h = default_func_file_h; end
if ~isfield(settings, 'data_file_h'), settings.data_file_h = default_data_file_h; end


if (strcmp(settings.data_type, 'fixed') == 1)
    
    default_integ_bits = 20;
    default_fract_bits = 20;
    
    if ~isfield(settings, 'integ_bits'), settings.integ_bits = default_integ_bits; end
    if ~isfield(settings, 'fract_bits'), settings.fract_bits = default_fract_bits; end
     
       
end
    
    


end