
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

    t = I_H*y-low_eig_inv*f;
    
    z = z1;
    z1 = min(t,ub);
    z1 = max(z1,lb);
    
    y = (1+beta)*z1 - beta*z;
    
    
end
