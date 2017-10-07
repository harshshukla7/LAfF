make_template('type','PL','project_name','laff_project', 'input', ' laff_in:10:float',  'output', ' laff_out:10:float');
 
current_path = pwd; 
 
dest_path_c = strcat(current_path, '/ip_design/src/user_laff_matrix_ops.cpp');
dest_path_h = strcat(current_path, '/ip_design/src/user_laff_matrix_ops.h');
copyfile('/home/hs/Repository/LAfF/src/user_laff_matrix_ops_orig.cpp', dest_path_c);
copyfile('/home/hs/Repository/LAfF/src/user_laff_matrix_ops_orig.h', dest_path_h);
 
 
source_c = strcat(current_path, '/user_laff_data.cpp');
source_h = strcat(current_path, '/user_laff_data.h');
dest_path_c = strcat(current_path, '/ip_design/src/user_laff_data.cpp');
dest_path_h = strcat(current_path, '/ip_design/src/user_laff_data.h');
copyfile(source_c, dest_path_c);
copyfile(source_h, dest_path_h);
 
 
source_c = strcat(current_path, '/user_laff_func.cpp');
source_h = strcat(current_path, '/user_laff_func.h');
dest_path_c = strcat(current_path, '/ip_design/src/user_laff_func.cpp');
dest_path_h = strcat(current_path, '/ip_design/src/user_laff_func.h');
copyfile(source_c, dest_path_c);
copyfile(source_h, dest_path_h);
 
 
source_c = strcat(current_path, '/user_laff_main.cpp');
source_h = strcat(current_path, '/user_laff_main.h');
dest_path_c = strcat(current_path, '/ip_design/src//user_laff_main.cpp');
dest_path_h = strcat(current_path, '/ip_design/src//user_laff_main.h');
copyfile(source_c, dest_path_c);
copyfile(source_h, dest_path_h);
 
 
dest_path_c = strcat(current_path, '/ip_design/src/foo_user.cpp');
copyfile('/home/hs/Repository/LAfF/src/foo_user_laff_orig.cpp', dest_path_c);
 
 
dest_m = strcat(current_path, '/ip_design/src/test_HIL.m'); 
copyfile('/home/hs/Repository/LAfF/main/setup/test_HIL_laff_orig.m', dest_m); 
 
source_dat = strcat(current_path, '/input_laff.mat');
desti_dat = strcat(current_path, '/ip_design/src/input_laff.mat');
copyfile(source_dat, desti_dat); 
 
ip_design_build('project_name','laff_project','fclk', 100);
 
%%% ip_design_build_debug('project_name','laff_project'); 
 
ip_prototype_build('project_name','laff_project','board_name','zedboard'); 
 
ip_prototype_load('project_name','laff_project','board_name','zedboard','type_eth','udp');
 
ip_prototype_test('project_name','laff_project','board_name','zedboard','num_test',1);
 
load('ip_design/src/output_protosplit.mat'); 
