function Vout = compute(XSimOut,varargin)
%COMPUTE Perform operation of the variable defined in the SimulationData
% object
%
% PropertyName:
% Cnames: cell array containg the name of variables
% Soperation: Specify the arithmetic operation to be performed (accettable
% values are: plus (+) minus (-)
%
%  Example:  Vout=compute('Cnames',{'var1','var2'},'Soperation','-')
%
% =====================================================
% COSSAN - COmputational Stochastic Structural Analysis
% IfM, Chair of Engineering Mechanics, LFU Innsbruck, A
% =====================================================


%% Validate input arguments
OpenCossan.validateCossanInputs(varargin{:})

for k=1:2:length(varargin)
    switch lower(varargin{k})
        case {'cnames'}
            Cnames=varargin{k+1};
        case {'soperation'}
            Soperation=varargin{k+1};
        otherwise
            error('openCOSSAN:SimulationData:compute', ...
                ['PropertyName (' varargin{k} ' ) is not allowed']);
    end
end

Vfield1=strcmp(XSimOut.Cnames,Cnames{1});

assert(sum(Vfield1)==1,'openCOSSAN:SimulationData:compute', ...
    ['The request variable %s is not present in the SimulationData object\nAvailable variables are: ' ...
    sprintf(' %s;',XSimOut.Cnames{:})],Cnames{1})

Vfield2=strcmp(XSimOut.Cnames,Cnames{2});
assert(sum(Vfield2)==1,'openCOSSAN:SimulationData:compute', ...
    ['The request variable %s is not present in the SimulationData object\nAvailable variables are: ' ...
    sprintf(' %s;',XSimOut.Cnames{:})],Cnames{2})

% Check if the values are also stored in the matrix format
if isempty(XSimOut.Mvalues)
    % Initialize structure
    Cdiff=struct2cell(XSimOut.Tvalues);
    
    % Remove fields
    C1=Cdiff(Vfield1,:);
    C2=Cdiff(Vfield2,:);
    
    if isempty(C1{end})
        C1=repmat(C1(1),1,length(C1));
    else
        Cout=C1;
    end
    
    if isempty(C2{end})
        C2=repmat(C2(1),1,length(C2));
    else
        Cout=C2;
    end
    
    switch Soperation
        case {'minus','-'}
            for i=1:length(C1)
                Cout{i}=C1{i}-C2{i};
            end
        case {'plus','+'}
            for i=1:length(C2)
                Cout{i}=C1{i}+C2{i};
            end
    end
    
    Vout = myCell2Mat(Cout);
    %Vout = cell2mat(Cout);
else
    switch Soperation
        case {'minus','-'}
            Vout=XSimOut.Mvalues(:,Vfield1)-XSimOut.Mvalues(:,Vfield2);
        case {'plus','+'}
            Vout=XSimOut.Mvalues(:,Vfield1)+XSimOut.Mvalues(:,Vfield2);
    end
end



