function [output] = laff_template_generator(number_inputs, number_outputs, settings)
%% Can have the following arguments
% nParam: number of parameters
% nPrimal: number of primal
% nDual: number of dual
% 1. settings.hardware: 'PL' for pure FPGA 
% 2. settings.data_type: 'float' or 'fixed', default: 'float'
% 3. settings.proj_name: any string, default name: 'split_project'
% 4. settings.target_platform: check protoip which platforms are supported,
% default platform: 'zedboard'
% 5. settings.target_frequency: string value of the target frequency (in MHz),
% default:100MHz
% 6. settings.number_test: character value, default:1
% 7. settings.x0
% 

%% hardware

default_hardware = 'PL';
settings.hardware = default_hardware;

%% What kind of data type
default_data_type = 'float';

if ~isfield(settings, 'data_type'), settings.data_type = default_data_type; end
if (strcmp(settings.data_type, 'fix') == 1)
    
    default_integ_bits = '15';
    default_fract_bits = '15';
    
    if ~isfield(settings, 'integ_bits'), settings.integ_bits = default_integ_bits; end
    if ~isfield(settings, 'fract_bits'), settings.fract_bits = default_fract_bits; end
    
    
end


%% project_name

default_proj_name = 'laff_project';
if ~isfield(settings, 'proj_name'), settings.proj_name = default_proj_name; end

%% target platform

default_target_platform = 'zedboard';
if ~isfield(settings, 'target_platform'), settings.target_platform = default_target_platform; end

%% target clock frequency

default_target_frequency = '100';
if ~isfield(settings, 'target_frequency'), settings.target_frequency = default_target_frequency;
else
    if (ischar(settings, 'target_frequency') == 0)
        
        error('please provide target frequency as a character, not a number or in any other format')
    end
end

%% number of tests

default_num_test = '1';
if ~isfield(settings, 'num_tests'), settings.num_tests = default_num_test; end


%% check which inputs variables are passed else assign some values!

if ~isfield(settings, 'laff_in'), settings.laff_in = zeros(1,number_inputs); end

laff_in = settings.laff_in;

save('input_laff.mat', 'laff_in');

%% set up for copy paste file


%%% matrix operations
mat_c = which('user_laff_matrix_ops_orig.cpp');
mat_h = which('user_laff_matrix_ops_orig.h');
mat_concat_c = '/ip_design/src/user_laff_matrix_ops.cpp';
mat_concat_h = '/ip_design/src/user_laff_matrix_ops.h';

%%% problem data
pd_c = '/user_laff_data.cpp';
pd_h = '/user_laff_data.h';
pd_concat_c = '/ip_design/src/user_laff_data.cpp';
pd_concat_h = '/ip_design/src/user_laff_data.h';


%%% laff func
func_c = '/user_laff_func.cpp';
func_h = '/user_laff_func.h';
func_concat_c = '/ip_design/src/user_laff_func.cpp';
func_concat_h = '/ip_design/src/user_laff_func.h';

%%% laff main
main_c = '/user_laff_main.cpp';
main_h = '/user_laff_main.h';
main_concat_c = '/ip_design/src//user_laff_main.cpp';
main_concat_h = '/ip_design/src//user_laff_main.h';


%%% test_HIL
th_source = which('test_HIL_laff_orig.m');
th_concat = ('/ip_design/src/test_HIL.m');

%%% copy paste input data file
input_data_source_concat = '/input_laff.mat';
input_data_dest_concat = '/ip_design/src/input_laff.mat';

%%% foo_user
foo_concat_c = '/ip_design/src/foo_user.cpp';
foo_algo_c = which('foo_user_laff_orig.cpp');
   

%% setting up for code generartion

hard = settings.hardware;
proj = default_proj_name;
clk = settings.target_frequency;
board = settings.target_platform;


if strcmp(settings.data_type, 'float')
    
    data_t = 'float';
    
elseif strcmp(settings.data_type, 'fix')
    data_t = strcat('fix:',settings.integ_bits, ':', settings.fract_bits);
    
else
    error('unknown data type');
end


%% code generation of template file

fileID = fopen('laff_template.m','w');

fprintf(fileID, 'make_template(''type'',''%s'',''project_name'',''%s'', ''input'', '' laff_in:%d:%s'',  ''output'', '' laff_out:%d:%s'');\n \n', hard, proj, number_inputs, data_t, number_outputs, data_t );

%%%%% copy files before start synthesising

fprintf(fileID, 'current_path = pwd; \n \n');


%%%% copy matrix operations
fprintf(fileID, 'dest_path_c = strcat(current_path, ''%s'');\n', mat_concat_c);
fprintf(fileID, 'dest_path_h = strcat(current_path, ''%s'');\n', mat_concat_h);
fprintf(fileID, 'copyfile(''%s'', dest_path_c);\n', mat_c );
fprintf(fileID, 'copyfile(''%s'', dest_path_h);\n \n \n', mat_h );


%%% problem data copy paste
fprintf(fileID, 'source_c = strcat(current_path, ''%s'');\n', pd_c);
fprintf(fileID, 'source_h = strcat(current_path, ''%s'');\n', pd_h);
fprintf(fileID, 'dest_path_c = strcat(current_path, ''%s'');\n', pd_concat_c);
fprintf(fileID, 'dest_path_h = strcat(current_path, ''%s'');\n', pd_concat_h);
fprintf(fileID, 'copyfile(source_c, dest_path_c);\n' );
fprintf(fileID, 'copyfile(source_h, dest_path_h);\n \n \n' );

%%% laff_func copy paste
fprintf(fileID, 'source_c = strcat(current_path, ''%s'');\n', func_c);
fprintf(fileID, 'source_h = strcat(current_path, ''%s'');\n', func_h);
fprintf(fileID, 'dest_path_c = strcat(current_path, ''%s'');\n', func_concat_c);
fprintf(fileID, 'dest_path_h = strcat(current_path, ''%s'');\n', func_concat_h);
fprintf(fileID, 'copyfile(source_c, dest_path_c);\n' );
fprintf(fileID, 'copyfile(source_h, dest_path_h);\n \n \n' );

%%% laff_main copy paste
fprintf(fileID, 'source_c = strcat(current_path, ''%s'');\n', main_c);
fprintf(fileID, 'source_h = strcat(current_path, ''%s'');\n', main_h);
fprintf(fileID, 'dest_path_c = strcat(current_path, ''%s'');\n', main_concat_c);
fprintf(fileID, 'dest_path_h = strcat(current_path, ''%s'');\n', main_concat_h);
fprintf(fileID, 'copyfile(source_c, dest_path_c);\n' );
fprintf(fileID, 'copyfile(source_h, dest_path_h);\n \n \n' );


%%% foo user copy paste
fprintf(fileID, 'dest_path_c = strcat(current_path, ''%s'');\n', foo_concat_c);
fprintf(fileID, 'copyfile(''%s'', dest_path_c);\n \n \n', foo_algo_c );


%%% copy paste test_hil
fprintf(fileID, 'dest_m = strcat(current_path, ''%s''); \n', th_concat);
fprintf(fileID, 'copyfile(''%s'', dest_m); \n \n', th_source);

%%% copy input data file

fprintf(fileID, 'source_dat = strcat(current_path, ''%s'');\n', input_data_source_concat);
fprintf(fileID, 'desti_dat = strcat(current_path, ''%s'');\n', input_data_dest_concat);

fprintf(fileID, 'copyfile(source_dat, desti_dat); \n \n' );




%%%%% copy ends

fprintf(fileID, 'ip_design_build(''project_name'',''%s'',''fclk'', %s);\n \n', proj, clk);

fprintf(fileID, '%%%%%% ip_design_build_debug(''project_name'',''%s''); \n \n', proj);

fprintf(fileID, 'ip_prototype_build(''project_name'',''%s'',''board_name'',''%s''); \n \n',proj, board);

fprintf(fileID, 'ip_prototype_load(''project_name'',''%s'',''board_name'',''%s'',''type_eth'',''udp'');\n \n', proj, board);
fprintf(fileID, 'ip_prototype_test(''project_name'',''%s'',''board_name'',''%s'',''num_test'',%s);\n \n',proj, board, settings.num_tests);

fprintf(fileID, 'load(''ip_design/src/output_laff.mat''); \n');
fclose(fileID);

while ~exist([pwd filesep 'laff_template.m'], 'file') ; end
output = 1;
%% delete all the folllowings
% if (isfield (settings))
% fprintf(fileID,'#define Size_Rows %d\n', Size_rows);
% fprintf(fileID,'#define Size_Columns %d\n', Size_columns);
% fprintf(fileID,'#define Num_PARAL %d\n', Num_Par);
% fprintf(fileID,'#define PART_Size %d\n', Part_size);
% fprintf(fileID,'#define REM_PART_Size %d\n', Rem_Part_size);
% fprintf(fileID,'#define ACC_Size %d\n\n', number_y_local);
%
% fprintf(fileID,strcat('void mv_mult(',data_t,' y_out[SIZE],',data_t,' x_in[SIZE]);\n'));
% fclose(fileID);


end