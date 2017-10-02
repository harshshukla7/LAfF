%% MATLAB implementation for parallel Mat-Vec product.

Size_rows = 100; % number of rows for the matrix
Size_columns = 100; % number of columns for the matrix
Num_Par = 5; % level of parallelism
Adder_Latency = 8; % number of clock cycles it takes for scaler addition
data_t = 'float';

%% Create Matrix and Vector for Multiplication y = A*x

H = rand(Size_rows, Size_columns);
x = rand(Size_columns, 1);
y = zeros(Size_rows,1);

%% Partion: in one partition keep all the columns and divide rows

Part_size = floor(Size_rows/Num_par); % partition matrix row wise
Rem_Part_size = Size_rows - (Part_size*Num_par); % find the last partition
par_number_y_local = ceil(Adder_Latency/Part_size); 
rem_number_y_local = ceil(Adder_Latency/Rem_Part_size); % Tricky. See documentation

number_y_local = par_number_y_local;

%% Code generation

fileID = fopen('mv_mult.h','w');
fprintf(fileID,'#define Size_Rows %d\n', Size_rows);
fprintf(fileID,'#define Size_Columns %d\n', Size_columns);
fprintf(fileID,'#define Num_PARAL %d\n', Num_Par);
fprintf(fileID,'#define PART_Size %d\n', Part_size);
fprintf(fileID,'#define REM_PART_Size %d\n', Rem_Part_size);
fprintf(fileID,'#define ACC_Size %d\n\n', number_y_local);

fprintf(fileID,strcat('void mv_mult(',data_t,' y_out[SIZE],',data_t,' x_in[SIZE]);\n'));
fclose(fileID);

%% need to modify from below

fileID = fopen('mv_mult.cpp','w');
fprintf(fileID,'#include "mv_mult.h"\n');
fprintf(fileID,'\n');
fprintf(fileID,strcat('void mv_mult(',data_t,' y_out[SIZE],',data_t,' x_in[SIZE])\n'));
fprintf(fileID,strcat('{\n'));
fprintf(fileID,strcat('\tshort i, i_acc, j, j_offset, k;\n\n'));
% print the matrix
fprintf(fileID,'\t// matrix \n');
tmp_mat = H(1:PAR*PART_SIZE,:);
fprintf(fileID,strcat('\t', data_t, ' H[PAR][PART_SIZE*SIZE] = {',sprintf('%2.16f,' , reshape(tmp_mat.',[],1)),'};\n'));
fprintf(fileID,'\t#pragma HLS ARRAY_PARTITION variable=H complete dim=1\n');
tmp_mat = H(PAR*PART_SIZE+1:end,:);
if isempty(tmp_mat)
    fprintf(fileID,strcat('\t', data_t, ' H_rem[REM_PART_SIZE*SIZE] = {','};\n\n'));
else
    fprintf(fileID,strcat('\t', data_t, ' H_rem[REM_PART_SIZE*SIZE] = {',sprintf('%2.16f,' , reshape(tmp_mat.',[],1)),'};\n\n'));
end


fprintf(fileID,'\t// local copy of the output vector\n');
fprintf(fileID,'\tfloat y_local[PAR][PART_SIZE][ACC_SIZE];\n');
fprintf(fileID,'\t#pragma HLS ARRAY_PARTITION variable=y_local complete dim=1\n');
fprintf(fileID,'\tfloat y_local_rem[REM_PART_SIZE][ACC_SIZE] ;\n\n');

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

fprintf(fileID,'\t// reset output vector\n');
fprintf(fileID,'\treset_output: for(i = 0; i < SIZE; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\t#pragma HLS PIPELINE\n');
fprintf(fileID,'\t\ty_out[i] = 0;\n');
fprintf(fileID,'\t}\n\n');
