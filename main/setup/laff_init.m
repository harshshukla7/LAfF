function [ output_args ] = laff_init( settings )
%Initial set up
%   settings.datatype       := 'float' or 'fixed'
%              default      :=  'float'
%   settings.interg_bits    := number of integer bits for fixed point
%              default      := 15
%   settings.frac_bits      := number of frac bits for fixed point
%              default      := 15
%   settings.vendor         := 'xilinx' or 'altera'
%              default      := 'xilinx'
%   settings.protoip        := 1 if protoip is installed
%              default      := 0
%   settings.size_inputs    := vector with dimension of each input (only for protoip)
%              default      := one input of dimension one i.e.
%                              scalar
%   settings.size_outputs   := vector with dimension of each output (only for protoip)
%             default       := one output with dimension one 

% TO DO : throw an error when arguments does not match with available
% options


%%% Dataype
if (isfield(settings,'datatype') == 1)
    
    datatype = settings.datatype;
    
else
    
    datatype = 'float';
    
end

%%% if fixed point then assign number of bits
if (strcmp(datatype,'fixed') == 1)
    
    if (isfield(settings, 'integ_bits') == 1)
        
        integ_bits = settings.integ_bits;
        
    else
        
        integ_bits = 15;
        
    end
    
    if (isfield(settings, 'frac_bits') == 1)
        
        frac_bits = settings.frac_bits;
        
    else
        
        frac_bits = 15;
        
    end
    
end

%%% Which vendor (need it for defining directive)
if (isfield(settings, 'vendor') == 1)
    
    vendor = settings.vendor;
    
else
    
    vendor = 'xilinx';
    
end


%%% define macros in h files


%%% check if protoip is installed for auto-deployment
if (isfield(settings, 'protoip') == 1)
    
    protoip = settings.protoip;
    
else
    
    protoip = 0;
    
end



%%% check number of inputs and dimensions

%%% check number of outputs and dimensions

%%% call make template for protoip



end

