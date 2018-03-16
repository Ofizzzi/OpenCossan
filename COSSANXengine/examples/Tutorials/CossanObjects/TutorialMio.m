% Tutorial for Mio.
% This tutorial shows how to construct and use a Mio object.

StutorialPath = fileparts(which('TutorialMio.m'));

%% Define additional objects
% In order to use a Mio, it is necessary to create an Input object and
% create a Model with such an input and the Mio. Please refer to the
% relevant objects tutorials for additional help.

% Create random variables and random variable set
Nrv = 7;
RV=RandomVariable('Sdistribution','normal', 'mean',0,'std',1);
% Define a set of Random Variables of Nrv independent, identically
% distributed random variables
Xrvs1=RandomVariableSet('Cmembers',{'RV'},'CXmembers',{RV},'Nrviid',Nrv); 

% Add a parameter
% The parameter is unnecessary here but it is used to test the behaviour of
% the Mio object.
Xpar=Parameter('value',5);

% Define Input object
Xinp  = Input;
Xinp  = Xinp.add('Xmember',Xrvs1,'Sname','Xrvs1');
Xinp  = Xinp.add('Xmember',Xpar,'Sname','Xpar');

% Add some samples to the Input
Xinp = Xinp.sample('Nsamples',10);
%% Define MIO 
% There are different ways to create a Mio object.
% The Mio can be a Matlab function or a Matlab script

%% Define Matlab Functions
% The input and Output can be passed as:
% A) Matlab structures
% B) Matlab arrays (each array correspond to a variable)
% C) single array (each column of the array correspond to a variable)

%% CASE A
% Matlab structures are used here for Input/Output. All the quantities
% contained in the input can be obtained in the input structure, in field
% names equal to the name of the input quantity.
%
% E.g.: Tinput(1).RV_1 contains the value of RV_1 for the first sample
%
% The Matlab function used is found in 'Files4Mio/ExampleMioStructure.m'

Xm  = Mio('Sdescription', 'Performance function', ...
                'Spath',fullfile(StutorialPath,'Files4Mio'), ...
                'Sfile','ExampleMioStructure.m', ...
                'Liostructure',true,... % This flag specify the type of I/O
                'Liomatrix',false, ...  % This flag specify the type of I/O
                'Coutputnames',{'Out1';'Out2'},... % This field is mandatory
                'Cinputnames',{'RV_1';'RV_2'},...  % This field is mandatory
				'Lfunction',true); % This flag specify if the .m file is a script or a function. 

% Test the Mio function 
XoutA = run(Xm,Xinp);
% The run mio return a SimulationData containg only the results of the
% Mio
display(XoutA)

            

%% First test - Use MonteCarlo simulation
%  Define Evaluator
Xev     = Evaluator('Xmio',Xm);
%  Define probmodel
Xmodel  = Model('XInput',Xinp,'XEvaluator',Xev); 
%  Apply
OpenCossan.cossanDisp('Test 1: 100 samples (20 batches) - MCS - MIO I/O Structures');
Xmc     = MonteCarlo('Nsamples',100,'Nbatches',20);
Xo      = Xmc.apply(Xmodel);

% The SimulationOuput Xo contains now also the realization of the random
% variables the values of parameters and functions if defined in the Input
% object
display(Xo)

%% CASE B
% Multiple vectors are used here for Input/Output. The input quantities are
% passed as a vector of sampled quantities in the order specified in the
% CinputNames field.
% Note that only mono-dimensional Parameters and Functions can be used with
% this input/output type.
%
% The Matlab function used is found in 'Files4Mio/ExampleMioFunction.m'
Xm  = Mio('Sdescription', 'Performance function', ...
                'Spath',fullfile(StutorialPath,'Files4Mio'), ...
                'Sfile','ExampleMioFunction', ...
                'Coutputnames',{'Out1' 'Out2'},... % This field is mandatory
                'Cinputnames',{'RV_1' 'RV_2' 'Xpar'},...    % This field is mandatory
                'Liostructure',false,...     % This flag specify the type of I/O
                'Liomatrix',false, ...  % This flag specify the type of I/O
				'Lfunction',true); % This flag specify if the .m file is a script or a function. 

% Test the Mio function 
XoutB = run(Xm,Xinp);

    
%%  Second - Use MonteCarlo simulation
%   Define Evaluator
Xev     = Evaluator('Xmio',Xm);
%  Define probmodel
Xmodel  = Model('XInput',Xinp,'XEvaluator',Xev); 
%   Apply
OpenCossan.cossanDisp('Test 2: 100 samples (20 batches) - MCS - MIO Function');
Xmc     = MonteCarlo('Nsamples',100,'Nbatches',20);
Xo      = Xmc.apply(Xmodel);

%% CASE C
% Matlab matrices are used here for Input/Output. Each row of the matrix
% correspond to a sample, and each column to an input quantity, in the
% order specified by the CinputNames field. As an example, the elements 
% (9,2) of the matrix in the Mio will contain the 9-th sampled value of
% RV_2.
% Please note that only random variables can be accessed with this
% input/output strategy.
%
% The Matlab function used is found in 'Files4Mio/ExampleMioMatrix.m'
Xm  = Mio('Sdescription', 'Performance function', ...
                'Spath',fullfile(StutorialPath,'Files4Mio'), ...
                'Sfile' ,'ExampleMioMatrix', ...
                'Coutputnames',{'Out1';'Out2'},... % This field is mandatory
                'Cinputnames',{'RV_1';'RV_2'},...    % This field is mandatory
                'Liostructure',false,...     % This flag specify the type of I/O
                'Liomatrix',true, ...  % This flag specify the type of I/O
				'Lfunction',true); % This flag specify if the .m file is a script or a function. 

% Test the Mio function 
XoutC = run(Xm,Xinp);
display(XoutC)

%% Define Matlab Script
% In this Mio, a script is used instead of a function. matlab script can be
% either passed from a file (not shown here), or passed in a single-line
% string, as shown here. 
% When using a script, either the structure or the matrix input/output can
% be used. When structure I/O is used, the "Tinput" and "Toutput" must
% mandatorily used as names of the input and output variables respectively.
% On the other hand, when matrix I/O is used, the names "Minput" and
% "Moutput" must be used.

Sscript=['for i=1:length(Tinput),'...
    'Toutput(i).Out1   = Tinput(i).RV_2;'...
    'Toutput(i).Out2   = Tinput(i).RV_1;'...
    'end'];

XmD  = Mio('Sdescription', 'Performance function', ...
                'Sscript',Sscript, ... % Define the script
                'Coutputnames',{'Out1';'Out2'},... % This field is mandatory
                'Cinputnames',{'RV_1';'RV_2'},...    % This field is mandatory
                'Liostructure',true,...     % This flag specify the type of I/O
                'Liomatrix',false, ...  % This flag specify the type of I/O
				'Lfunction',false); % This flag specify if the .m file is a script or a function. 

% Test the Mio function 
XoutD = run(XmD,Xinp);
display(XoutD)
% All the three different interface should produce 


%% Third test - Use MonteCarlo simulation
%8.1.   Define Evaluator
Xev     = Evaluator('Xmio',Xm);
%8.2.   Define probmodel
Xmodel  = Model('XInput',Xinp,'XEvaluator',Xev); 
%8.3.   Apply
OpenCossan.cossanDisp('Test 3: 100 samples (20 batches) - MCS - MIO Matrix');
Xmc     = MonteCarlo('Nsamples',100,'Nbatches',20);
Xo      = Xmc.apply(Xmodel);

