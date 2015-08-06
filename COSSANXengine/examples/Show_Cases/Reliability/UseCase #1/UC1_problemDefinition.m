% Thi USE CASE #1 analyze a system composed by parallel components. 
% Author: EP
%
disp('');
disp('--------------------------------------------------------------------------------------------------');
disp('USE CASE #1: Parallel system from S.Engelung and R. Rackwitz. Structural Safety, 12 (1993)');
disp('--------------------------------------------------------------------------------------------------');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example # 5 (pag.271) from the paper:
% "A benchmark study on importance sampling techniques in structural
% reliability" S.Engelung and R. Rackwitz. Structural Safety, 12 (1993)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define the input parameters
% In this example there are 5 random variable (standard normal) and 4
% limit state functions. 

RV=RandomVariable('Sdistribution','normal','mean',0,'std',1); 

% Definition of Set of IID random variables 
Xrvs = RandomVariableSet('Xrv',RV,'Nrviid',5);

% Define Input
Xin = Input('XRandomVariableSet',Xrvs);

%%  Definition of Mio objects
% The mio object contains the performance fucntion
Sfolder=fileparts(which('UC1_problemDefinition.m'));% returns the current folder
Spath=fullfile(Sfolder,'performancefunctions');
XmA=Mio('Sdescription', 'Performance function', ...
        'Spath',Spath, ...
        'Sfile','performance_functionAT', ...
        'Liostructure',true, ...
        'Lfunction',true, ...
        'Liomatrix',false, ...
        'Coutputnames',{'outA'},...
        'Cinputnames',{'RV_1' 'RV_2'});		
			
XmB=Mio('Sdescription', 'Performance function', ...
        'Spath',Spath, ...
        'Sfile','performance_functionBT', ...
        'Lfunction',true, ...
        'Liostructure',true, ...
        'Liomatrix',false, ...
        'Coutputnames',{'outB'},...
        'Cinputnames',{'RV_2' 'RV_3'});		
			
XmC=Mio('Sdescription', 'Performance function', ...
        'Spath',Spath, ...
        'Sfile','performance_functionCT', ...
        'Lfunction',true, ...
        'Liostructure',true, ...
        'Liomatrix',false, ...        
        'Coutputnames',{'outC'},...
        'Cinputnames',{'RV_3' 'RV_4'});		
			
    
XmD=Mio('Sdescription', 'Performance function', ...
        'Spath',Spath, ...
        'Sfile','performance_functionDT', ...
        'Lfunction',true, ...
        'Liostructure',true, ...
        'Liomatrix',false, ...
        'Coutputnames',{'outD'},...
        'Cinputnames',{'RV_4' 'RV_5'});	

% For verification purpose we can also create a performance function
% containg all the limit state functions. In this case in not possible to
% compute the pf associate to each performance function.

XmALL=Mio('Sdescription', 'Performance function', ...
        'Spath',Spath, ...
        'Sfile','performance_function_allT', ...
        'Lfunction',true, ...
        'Liostructure',true, ...
        'Liomatrix',false, ...
        'Coutputnames',{'outALL'},...
        'Cinputnames',{'RV_1' 'RV_2' 'RV_3' 'RV_4' 'RV_5'});	
			
% Define Performance Functions
XpfA=PerformanceFunction('Xmio',XmA);
XpfB=PerformanceFunction('Xmio',XmB);
XpfC=PerformanceFunction('Xmio',XmC);
XpfD=PerformanceFunction('Xmio',XmD);
XpfALL=PerformanceFunction('Xmio',XmALL);

% Construct the evaluators
% The evaluator is empty since there is no model to be evaluated.
Xev= Evaluator;

% Define the Models
Xmdl= Model('Xevaluator',Xev,'Xinput',Xin);

% Define Single Probabilistic Model 
% this probabilistic model contain the performance function defined by the
% intersection of the performance functions (i.e. max)
XpmALL=ProbabilisticModel('Xmodel',Xmdl,'XperformanceFunction',XpfALL);

%% Define a SystemReliability model 
% The first step to construct a system realibility model is to define a
% Fault Tree object

CnodeTypes={'Output','AND','Input','Input','Input','Input'};
CnodeNames={'TopEvent','AND gate','A','B','C','D'};
VnodeConnections=[0 1 2 2 2 2];

Xft=FaultTree('CnodeTypes',CnodeTypes,'CnodeNames',CnodeNames,...
               'VnodeConnections',VnodeConnections, ...
               'Sdescription','FaultTree object UC1');

% Summary of the FaultTree
display(Xft)

% Display the FaultTree
Xft.plotTree

% Identify the minimal cut-sets
Xft=Xft.findMinimalCutSets;

display(Xft)           

% Now we can construct a SystemReliability object composed by the
% PerformanceFunction objects, a Model and the FaultTree

Xsys=SystemReliability('Cmembers',{'XpmA';'XpmB';'XpmC';'XpmD'},...
     'XperformanceFunctions',[XpfA XpfB XpfC XpfD], ...
     'Xmodel',Xmdl,'XFaultTree',Xft);
 