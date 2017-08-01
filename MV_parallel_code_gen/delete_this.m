function output = delete_this(H, paral, varargin)

%% Mandatory input arguments:
% 1. Input Matrix H
% 2. Level of parallelism
%  Optional input arguments
% 1. 'matrix_name': Name of the matrix
% 2. 'input_vector': value of input vector
% 3. 'input_vector_name': name of the input vector
% 4. 'output_vector_name': name of the output vector
% 5. 'adder_latency': 
% 6. 'data_type': float or fixed
% 7. 'interg_bits': number of integer bits
% 8. 'frac_bits': number of fraction bits

p = inputParser;

default_matrix_name = 'H';
default_input_vector_name = 'x';
default_output_vector_name = 'y';
default_data_type = 'float';
default_adder_latency = 8;
default_integ_bits = 20;
default_frac_bits = 20;

addRequired(p, 'H', @isnumeric);
addRequired(p, 'paral', @isnumeric);

addParameter(p, 'matrix_name', default_matrix_name, @(x) ischar(x));
addParameter(p, 'input_vector', rand(size(H,2),1), @(x) isnumeric(x));
addParameter(p, 'input_vector_name', default_input_vector_name, @(x) ischar(x));
addParameter(p, 'output_vector_name', default_output_vector_name, @(x) ischar(x));
addParameter(p, 'adder_latency', default_adder_latency, @(x) isnumeric(x));
addParameter(p, 'data_type', default_data_type, @(x) any(validatestring(x, {'float', 'fixed'})));

if(strcmp(p.data_type, 'fixed'))
    
    addParameter(p, 'integ_bits', dafault_integ_bits, @(x) isnumeric(x));
    

end