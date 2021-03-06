number_elements = 12;

vec_elements = rand(number_elements,1);
true_answer = sum(vec_elements);


%% The algorithm is based on single elimination tournament
%%% Compute the higher power of 2 than the given number


% Idea: Convert decimal to binary and check the number of digits
number_binary = de2bi(number_elements);

if (nnz(number_binary) == 1)
    
    byes = 0;
    power_of_2 = length(number_binary)-1;
    
else 
    
    power_of_2 = length(number_binary);
    byes = 2^(power_of_2) - number_elements;
    
end


%% obtain local variables which is nothing but geometric series sum
% sum_formula = (r^(n+1)-1)/(r-1)

r_geo = 2;
n_geo = power_of_2 ;

total_local = (r_geo^(n_geo) - 1)/(r_geo - 1);

%%% easier way is of course just to say (r_geo^(n_geo) - 1)

sum_local = zeros(total_local,1);

%% 

depth_tree = n_geo;

index_count = 1; 
counting_index = 1;
        
pow_depth_tree_1 = 1;

for i= depth_tree:-1:1
    
    if (i == depth_tree)
        
        for j = 1:byes
            
            sum_local(index_count) = vec_elements(j);
            index_count = index_count + 1;
            
        end
        
        for j= byes+1:2:number_elements
            
            sum_local(index_count) = vec_elements(j) + vec_elements(j+1);
            index_count = index_count + 1;
        end
        
        
    else 
        
        pow_depth_tree_1 = 2^(i  ) + pow_depth_tree_1;
        pow_depth_tree_2 = 2^(i- 1);
        
        
        
        for j= pow_depth_tree_1:pow_depth_tree_2 + pow_depth_tree_1 -1 
            
            sum_local(j) = sum_local(counting_index)  + sum_local(counting_index+1);
            
            counting_index =   counting_index + 2;
            
           
            
        end
        
%         counting_index = counting_index + 2^(depth_tree - i -1) ;
        
    end
    
    
    
    
end

t_adder_tree_answer = sum_local(end)