function laff_write_data(name, x, type)
%
% if x is matrix then it is saved column wise


if ((size(x,1)>1 && size(x,2)>1))
    
    total_elements = size(x,1)*size(x,2);
    
    x = reshape(x, 1, total_elements);
    
end


%% add data declaration in h file

fd  = fopen('user_laff_data.h','a');

%%%% check if it a scalar
if ((size(x,1) == 1 && size(x,2) == 1))
    
    if (strcmp(type, 'int'))
        
        fprintf(fd, 'extern int %s; \n', name);
        
    else
       
        fprintf(fd, 'extern real %s; \n', name);
        

    end
    
    
%%% if it is a vector    
else
    
    
    if (strcmp(type, 'int'))
        
        fprintf(fd, 'extern int %s[%d]; \n', name, length(x));
        
        
    else
        
        fprintf(fd, 'extern real %s[%d]; \n', name, length(x));
        
    end
end

fclose(fd);


%% write data in c file


fd  = fopen('user_laff_data.cpp','a');

%%%% check if it a scalar
if ((size(x,1) == 1 && size(x,2) == 1))
    
    if (strcmp(type, 'int'))
        
        fprintf(fd, 'int %s = %d; \n', name, x);
        
    else
       
        fprintf(fd, 'real %s = %2.16f; \n', name, x);
        

    end
    
    
%%% if it is a vector    
else
    
    
    if (strcmp(type, 'int'))
        
        fprintf(fd, 'int %s[%d] = {%d', name, length(x), x(1));
        fprintf(fd, ',%d', x(2:end));
        fprintf(fd, '};\n');
        
        
    else
        
        fprintf(fd, 'real %s[%d] = {%2.16f', name, length(x), x(1));
        fprintf(fd, ',%2.16f', x(2:end));
        fprintf(fd, '};\n');
        
    end
end

fclose(fd);
       

end