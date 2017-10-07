clear all; close all; clc

n = 5;
iterations = 1000;
lmin = -1;
umax = 1;

H = 50*rand(n,n);
H = H'*H;
f = -1*ones(n,1);

lb = lmin*ones(n,1);
ub = umax*ones(n,1);

x_quadprog = quadprog(H,f,[],[],[],[],lb,ub);

%% FGM method setup

eig_val = eig(H);

lowest_sqrt = sqrt(eig_val(1));
highest_sqrt =  sqrt(eig_val(end));

beta = (highest_sqrt-lowest_sqrt)/(highest_sqrt+lowest_sqrt);

z1 = zeros(n,1);
y = z1;
z = z1;

I_H = eye(n)-H/eig_val(end);
low_eig_inv = 1/eig_val(end);

%% FGM algorithm

for i=1:iterations

    
    
    z = z1;
    t = I_H*y-low_eig_inv*f;
    z1 = min(t,ub);
    z1 = max(z1,lb);
    
    y = (1+beta)*z1 - beta*z;
    
    
end


%% initial setup

laff_init(10,10,[]);

%% code generation using laff

laff_write_data('I_H', I_H, 'real');
laff_write_data('lf', low_eig_inv*f, 'real');
laff_write_data('lb', lb, 'real');
laff_write_data('ub', ub, 'real');
laff_write_data('beta_1', beta+1, 'real');
laff_write_data('beta', beta, 'real');
laff_write_data('itr', iterations, 'int');
laff_write_data('z', zeros(n,1), 'real');
laff_write_data('z_prev', zeros(n,1), 'real');
laff_write_data('y', zeros(n,1), 'real');
laff_write_data('t', zeros(n,1), 'real');


%% add functions
PAR_requested = 1;

% begin for algorithm
laff_for_loop_begin('itr', 'main_loop');

% copy vector
laff_copy_vector('z_prev', 'z', n);

% matrix vector
laff_MV_MAC(I_H, PAR_requested, 'y', 'z', []);

% vector subtraction
laff_vector_scale_add('t', 'z', 'lf', n, 1, -1 );


% min max operation
laff_box_clipping('z', 't', n, lmin, umax);

% vector scaling and subtraction
laff_vector_scale_add('y', 'z', 'z_prev', n, (1+beta), -beta );

%end for algorithm
laff_for_loop_end;

laff_end;

%% for ProtoIP
number_inputs_protoip = 10;
number_outputs_protoip = 10;
laff_template_generator(number_inputs_protoip, number_outputs_protoip , []);

%% Deploy on FPGA

% laff_template;

