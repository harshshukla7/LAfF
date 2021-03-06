function [] = laff_MV_MAC(H, PAR_requested, input_name, output_name, settings)

% this script generates FPGA synthesisable C code for dense matrxi vector
% multiplication y_out = H*x_in with variable degree parallelism
% (i.e. number of multiply-accumulate units). The matrix and degree of 
% parallelism must be known at code generation stage.

%% parameters (defined by user)
% SIZE = 130; % matrix size
% H = rand(SIZE,SIZE); % matrix is specified by the user
% PAR_requested  = 39; % requested degree of parallelism, must be in the range 1:SIZE. 
% ADDER_LATENCY = 8; % max allowed adder latency (usually in the range 8 to 12 clock cycles)
% data_t = 'float';


if (~isfield (settings, 'adder_lat')); settings.adder_lat = 8; end

 ADDER_LATENCY = settings.adder_lat; % max allowed adder latency (usually in the range 8 to 12 clock cycles)
 
 
 data_t = 'data_t_laff_in_in';
 
  
 SIZE_row = size(H,1);
 SIZE_col = size(H,2);
 
%% parameters checking and adjustment
PART_SIZE = ceil(SIZE_row/PAR_requested); % data partitions size
PAR = floor(SIZE_row/PART_SIZE); % number of parallel MAC units (excluding the reaminder partition)
REM_PART_SIZE = SIZE_row - PAR*PART_SIZE; % remainder partition size
% For example if SIZE_row = 10, PAR_requested = 4 then:
% PART_SIZE = 3; PAR = 3, REM_PART_SIZE = 1;
ACC_SIZE = ceil(ADDER_LATENCY/PART_SIZE); % using vectorized accumulator allows allows avoiding read-write dependencies


%% call the function from main file

fileID = fopen('user_laff_main.cpp','a');
fprintf(fileID,strcat('mv_mult(', output_name, ',', input_name, ');\n'));
fclose(fileID);


%% generate code 
fileID = fopen('user_laff_func.h','a');
fprintf(fileID,'#include "foo_data.h"\n');
fprintf(fileID,'#define SIZE_row %d\n', SIZE_row);
fprintf(fileID,'#define SIZE_col %d\n', SIZE_col);
fprintf(fileID,'#define PAR %d\n', PAR);
fprintf(fileID,'#define PART_SIZE %d\n', PART_SIZE);
fprintf(fileID,'#define REM_PART_SIZE %d\n', REM_PART_SIZE);
fprintf(fileID,'#define ACC_SIZE %d\n\n', ACC_SIZE);

fprintf(fileID,strcat('void mv_mult(',data_t,' y_out[SIZE_row],',data_t,' x_in[SIZE_col]);\n'));
fclose(fileID);


fileID = fopen('user_laff_func.cpp','a');
fprintf(fileID,'\n');
fprintf(fileID,strcat('void mv_mult(',data_t,' y_out[SIZE_row],',data_t,' x_in[SIZE_col])\n'));
fprintf(fileID,strcat('{\n'));
% fprintf(fileID,strcat('#pragma HLS INLINE \n'));
fprintf(fileID,strcat('\tint i, i_acc, j, k;\n'));
fprintf(fileID,strcat('\tlong int j_offset;\n\n'));
% print the matrix
fprintf(fileID,'\t// matrix \n');
tmp_mat = H(1:PAR*PART_SIZE,:);
fprintf(fileID,strcat('\tstatic',32, data_t, ' H[PAR][PART_SIZE*SIZE_col] = {',sprintf('%2.16f,' , reshape(tmp_mat.',[],1)),'};\n'));
fprintf(fileID,'\t#pragma HLS ARRAY_PARTITION variable=H complete dim=1\n');
tmp_mat = H(PAR*PART_SIZE+1:end,:);
if isempty(tmp_mat)
    fprintf(fileID,strcat('\tstatic',32, data_t, ' H_rem[REM_PART_SIZE*SIZE_col] = {','};\n\n'));
else
    fprintf(fileID,strcat('\tstatic',32, data_t, ' H_rem[REM_PART_SIZE*SIZE_col] = {',sprintf('%2.16f,' , reshape(tmp_mat.',[],1)),'};\n\n'));
end


fprintf(fileID,'\t// local copy of the output vector\n');
fprintf(fileID,strcat('\t',data_t,' y_local[PAR][PART_SIZE][ACC_SIZE];\n'));
fprintf(fileID,'\t#pragma HLS ARRAY_PARTITION variable=y_local complete dim=1\n');
fprintf(fileID,'\t#pragma HLS RESOURCE variable=y_local core=RAM_2P_LUTRAM\n');
fprintf(fileID,strcat('\t',data_t,' y_local_rem[REM_PART_SIZE][ACC_SIZE] ;\n'));
fprintf(fileID,'\t#pragma HLS RESOURCE variable=y_local_rem core=RAM_2P_LUTRAM\n\n');

fprintf(fileID,'\t// reset local output vectors\n');
fprintf(fileID,'\treset_local_1: for(i = 0; i < PART_SIZE; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\treset_local_2: for(j = 0; j < ACC_SIZE; j++)\n');
fprintf(fileID,'\t\t{\n');
fprintf(fileID,'\t\t\t#pragma HLS PIPELINE\n');
fprintf(fileID,'\t\t\t#pragma HLS LOOP_FLATTEN\n');
fprintf(fileID,'\t\t\treset_local_3: for(k = 0; k < PAR; k++)\n');
fprintf(fileID,'\t\t\t{\n');
fprintf(fileID,'\t\t\t\t#pragma HLS UNROLL skip_exit_check\n');
fprintf(fileID,'\t\t\t\ty_local[k][i][j] = 0;\n');
fprintf(fileID,'\t\t\t}\n');
fprintf(fileID,'\t\t}\n');
fprintf(fileID,'\t}\n');
fprintf(fileID,'\treset_local_rem_1: for(i = 0; i < REM_PART_SIZE; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\treset_local_rem_2: for(j = 0; j < ACC_SIZE; j++)\n');
fprintf(fileID,'\t\t{\n');
fprintf(fileID,'\t\t\t#pragma HLS PIPELINE\n');
fprintf(fileID,'\t\t\t#pragma HLS LOOP_FLATTEN\n');
fprintf(fileID,'\t\t\t#if REM_PART_SIZE\n');
fprintf(fileID,'\t\t\ty_local_rem[i][j] = 0;\n');
fprintf(fileID,'\t\t\t#endif\n');
fprintf(fileID,'\t\t}\n');
fprintf(fileID,'\t}\n\n');

% fprintf(fileID,'\t// reset output vector\n');
% fprintf(fileID,'\treset_output: for(i = 0; i < SIZE; i++)\n');
% fprintf(fileID,'\t{\n');
% fprintf(fileID,'\t\t#pragma HLS PIPELINE\n');
% fprintf(fileID,'\t\ty_out[i] = 0;\n');
% fprintf(fileID,'\t}\n\n');

fprintf(fileID,'\t// matrix vector multiplication\n');
fprintf(fileID,'\tmv_1: for(i = 0, i_acc = 0; i < SIZE_col; i++, i_acc++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tmv_2: for(j = 0, j_offset = 0; j < PART_SIZE; j++, j_offset+=SIZE_col)\n');
fprintf(fileID,'\t\t{\n');
fprintf(fileID,'\t\t\t#pragma HLS DEPENDENCE variable=y_local inter distance=%d true\n',ADDER_LATENCY);
fprintf(fileID,'\t\t\t#pragma HLS DEPENDENCE variable=y_local_rem inter distance=%d true\n',ADDER_LATENCY);
fprintf(fileID,'\t\t\t#pragma HLS PIPELINE\n');
fprintf(fileID,'\t\n');
fprintf(fileID,'\t\t\tif (i_acc == ACC_SIZE)\n');
fprintf(fileID,'\t\t\t{\n');
fprintf(fileID,'\t\t\t\ti_acc = 0;\n');
fprintf(fileID,'\t\t\t}\n');
fprintf(fileID,'\t\t\tmv_3: for(k = 0; k < PAR; k++)\n');
fprintf(fileID,'\t\t\t{\n');
fprintf(fileID,'\t\t\t\t#pragma HLS UNROLL skip_exit_check\n');
fprintf(fileID,'\t\t\t\ty_local[k][j][i_acc] += H[k][j_offset+i]*x_in[i];\n');
fprintf(fileID,'\t\t\t}\n');
fprintf(fileID,'\t\t\tif(j < REM_PART_SIZE)\n');
fprintf(fileID,'\t\t\t{\n');
fprintf(fileID,'\t\t\t\ty_local_rem[j][i_acc] += H_rem[j_offset+i]*x_in[i];\n');
fprintf(fileID,'\t\t\t}\n');
fprintf(fileID,'\t\t}\n');
fprintf(fileID,'\t}\n\n');

fprintf(fileID,'\t// fill the output vector from the local output vector\n');
fprintf(fileID,'\toutput_1: for(i = 0; i < ACC_SIZE; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\toutput_2: for(j = 0; j < PART_SIZE; j++)\n');
fprintf(fileID,'\t\t{\n');
fprintf(fileID,'\t\t\toutput_3: for(k = 0; k < PAR + !(!(REM_PART_SIZE)); k++)\n');
fprintf(fileID,'\t\t\t{\n');
fprintf(fileID,'\t\t\t\t#pragma HLS PIPELINE\n');
fprintf(fileID,'\t\t\t\t#pragma HLS DEPENDENCE variable=y_out inter distance=%d true\n',PART_SIZE*PAR);

fprintf(fileID,'\t\t\t\tif(i == 0)\n');
fprintf(fileID,'\t\t\t\t{\n');

fprintf(fileID,'\t\t\t\t\tif(k == PAR)\n');
fprintf(fileID,'\t\t\t\t\t{\n');
fprintf(fileID,'\t\t\t\t\t\tif(j < REM_PART_SIZE)\n');
fprintf(fileID,'\t\t\t\t\t\t{\n');
fprintf(fileID,'\t\t\t\t\t\t\ty_out[k*PART_SIZE + j] = y_local_rem[j][i];\n');
fprintf(fileID,'\t\t\t\t\t\t}\n');
fprintf(fileID,'\t\t\t\t\t}\n');
fprintf(fileID,'\t\t\t\t\telse\n');
fprintf(fileID,'\t\t\t\t\t{\n');
fprintf(fileID,'\t\t\t\t\t\ty_out[k*PART_SIZE+j] = y_local[k][j][i];\n');
fprintf(fileID,'\t\t\t\t\t}\n');

fprintf(fileID,'\t\t\t\t}\n');
fprintf(fileID,'\t\t\t\telse\n');
fprintf(fileID,'\t\t\t\t{\n');


fprintf(fileID,'\t\t\t\t\tif(k == PAR)\n');
fprintf(fileID,'\t\t\t\t\t{\n');
fprintf(fileID,'\t\t\t\t\t\tif(j < REM_PART_SIZE)\n');
fprintf(fileID,'\t\t\t\t\t\t{\n');
fprintf(fileID,'\t\t\t\t\t\t\ty_out[k*PART_SIZE + j] += y_local_rem[j][i];\n');
fprintf(fileID,'\t\t\t\t\t\t}\n');
fprintf(fileID,'\t\t\t\t\t}\n');
fprintf(fileID,'\t\t\t\t\telse\n');
fprintf(fileID,'\t\t\t\t\t{\n');
fprintf(fileID,'\t\t\t\t\t\ty_out[k*PART_SIZE+j] += y_local[k][j][i];\n');
fprintf(fileID,'\t\t\t\t\t}\n');
fprintf(fileID,'\t\t\t\t}\n');

fprintf(fileID,'\t\t\t}\n');

fprintf(fileID,'\t\t}\n');
fprintf(fileID,'\t}\n\n\n');

fprintf(fileID,strcat('}\n'));
fclose(fileID);

% %% copy code to protoip project
% copyfile('mv_mult.cpp','ip_design/src/')
% copyfile('mv_mult.h','ip_design/src/')

end
