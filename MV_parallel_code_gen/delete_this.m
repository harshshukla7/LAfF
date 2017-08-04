function output = delete_this(H, paral, settings)

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


default_matrix_name = 'H';
default_input_vector_name = 'x';
default_output_vector_name = 'y';
default_data_type = 'float';
default_adder_latency = 8;


if ( isnumeric(H) == 0 || size(H,1) == 1 || size(H,2) == 1)
    
    error('Input matrix must be numeric and not scalar or vector')
    
end

if( isnumeric(paral) == 0  || isscalar(paral) == 0)
    
    error('Requested level of parallellism should be scalar and numeric')

end


if ~isfield(settings, 'matrix_name') settings.matrix_name = default_matrix_name; end
if ~isfield(settings, 'input_vector') settings.input_vector = rand(size(H,2),1); end
if ~isfield(settings, 'input_vector_name') settings.input_vector_name = default_input_vector_name; end
if ~isfield(settings, 'output_vector_name') settings.output_vector_name = default_output_vector_name; end
if ~isfield(settings, 'data_type') settings.data_type = default_data_type; end
if ~isfield(settings, 'adder_latency') settings.adder_latency = default_adder_latency; end


if (strcmp(settings.data_type, 'fixed') == 1)
    
    default_integ_bits = 20;
    default_fract_bits = 20;
    
    if ~isfield(settings, 'integ_bits') settings.integ_bits = default_integ_bits; end
    if ~isfield(settings, 'fract_bits') settings.fract_bits = default_fract_bits; end
     
       
end
    
    


end