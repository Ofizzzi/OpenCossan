%% Tutorial for the connector using code_aster
% TODO: Add description
% TODO: which kind of example is? What is the model??????
%
%  Copyright 1993-2011, COSSAN Working Group
%  University of Innsbruck, Austria
%
% See Also: 
% http://cossan.cfd.liv.ac.uk/wiki/index.php/@Connector

% Reset the random number generator in order to obtain always the same results.
% DO NOT CHANGE THE VALUES OF THE SEED
OpenCossan.resetRandomNumberGenerator(51125)

%% Input definition
E = RandomVariable('Sdistribution','normal','mean',2.100e11,'std',2.100e10);
leng1 = RandomVariable('Sdistribution','normal','mean',5e-3,'std',5e-4);
leng2 = RandomVariable('Sdistribution','normal','mean',5e-3,'std',5e-4);
leng3 = RandomVariable('Sdistribution','normal','mean',5e-3,'std',5e-4);
leng4 = RandomVariable('Sdistribution','normal','mean',5e-3,'std',5e-4);

Xrvs    = RandomVariableSet('Cmembers',{'E','leng1','leng2','leng3','leng4'},...
    'Xrv',[Xrv1,Xrv2,Xrv2,Xrv2,Xrv2]);

Xin     = Input('CXmembers',{Xrvs},'CSmembers',{'Xrvs'});

%% 1. Create the Injector
Sfolder=fileparts(mfilename('fullpath'));% returns the current folder
Spath= fullfile(Sfolder,'Connector','ASTER');
Xi=Injector('Srelativepath','./','Sscanfilepath',Spath,...
    'Sscanfilename','Cas.cossan','Sfile','Cas.comm');

%% Extractor


%  Build response
Xresp_sif = Response('Sname','OUT1', ...
             'Sfieldformat', '%12e', ...
             'Clookoutfor', { 'K1';}, ...
             'Ncolnum',41, ...
             'Nrownum',1 );
%  Build extractor
Xe=Extractor( 'Xresponse',Xresp_sif, ...
             'Sdescription','Extractor for the plate', ...
             'Srelativepath','./', ...
             'Sfile','Cas.resu' ...
             );
%%  Construct the connector

% create the connector
Xc= Connector('SpredefinedType','aster','Smaininputfile','Cas',...
    'Smaininputpath',Spath,...
    'Soutputfile','Cas.resu','Sworkingdirectory','/tmp',...
    'Lkeepsimulationfiles',true,...
    'CXmemebers',{Xi, Xe});

%% Execute the simulation
% In oreder to execute the simulation, it is necessary to create an
% Evaluator. This Evaluator will be then included in a Model, and the Model
% will be executed with a simulation (i.e., Monte Carlo). The simulations
% will be executed remotely using the GridEngine.

Xjm = JobManagerInterface('Stype','GridEngine');

Xeval = Evaluator('Xconnector',Xc,'XJobManagerInterface',Xjm,'CSqueues',{'pizzas64.q'});
% create Model
Xm = Model('Xinput',Xin,'Xevaluator', Xeval);
% Monte Carlo simulation
Xmc = Montecarlo('Nsamples',3);
Xo = Xmc.apply(Xm);

Vout=Xo.getValues('Sname','OUT1');

% Plot Results
f1=figure;
fah=gca(f1);
plot(fah,Vout,'*');
%% Close Figures
close(f1)

% Validate Solution
% TODO: Add reference solution
Vreference=[-16586600, 15189400, -19478800]';
assert(max(abs(Vout-Vreference))<1e-6,...
    'CossanX:Tutorials:TutorialConnectorASTER','Reference Solution does not match.')


