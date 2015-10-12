%% TUTORIALCROSSENTROPY
% This turorial shows how to perform Optimization of Himmelblau Function using 
%   the Cross Entropy Method
%
% See Also:  http://cossan.cfd.liv.ac.uk/wiki/index.php/@CrossEntropy
%
% $Copyright~1993-2011,~COSSAN~Working~Group,~University~of~Innsbruck,~Austria$
% $Author:~Edoardo~Patelli$ 


%% prepate Input objects
% The Himmelblau function requires two design variables. The design variables
% are defined by means of the parameters objects.

% Create DesignVariable objects
X1      = DesignVariable('Sdescription','design variable 1','value',0); 
X2      = DesignVariable('Sdescription','design variable 2','value',0);
% Create an Input object containing the design variables
Xin     = Input('Sdescription','Input for the Himmelblau function','CSmembers',{'X1' 'X2'},'CXmembers',{X1 X2});

%% Create objective function
Xofun   = ObjectiveFunction('Sdescription','Himmelblau function', ...
         'Lfunction',true,'Liomatrix',true,'Liostructure',false,...
          'Cinputnames',{'X1','X2'},... % Define the inputs 
          'Spath',fullfile(OpenCossan.getCossanRoot,'examples','Models','MatlabFunctions','Himmelblau'),...
          'Sfile','Himmelblau',... % external file
          'Coutputnames',{'fobj'}); % Define the outputs
      

% Reset the random number generator in order to obtain always the same results.
% DO NOT CHANGE THE VALUES OF THE SEED
OpenCossan.resetRandomNumberGenerator(46354)
%%  Create initial (random) solution
Minisol     = unifrnd(-5,5,40,2);

%% Define OptimizationProblem
Xop     = OptimizationProblem('Sdescription','Himmelblau optimization problem','Xinput',Xin,...
    'XobjectiveFunction', Xofun,'MinitialSolutions',Minisol);

%% Create optimizer object CrossEntropy
Xce     = CrossEntropy('NFunEvalsIter',40,'NUpdate',20,'Lintermediateresults',true);

% Show details of the object
display(Xce)
%% Solve optimization problem
Xoptimum  = Xce.apply('XoptimizationProblem',Xop);
display(Xoptimum)

%% Reference Solution
OpenCossan.cossanDisp(' ');
OpenCossan.cossanDisp('Reference solution');
OpenCossan.cossanDisp('f(3.0,2.0) = 0.0');
OpenCossan.cossanDisp('f(-2.805118, 3.131312) = 0.0');
OpenCossan.cossanDisp('f(-3.779310, -3.283186) = 0.0');
OpenCossan.cossanDisp('f(3.584428, -1.848126) = 0.0');

%% Validate solution
Vreference=[3 0];
assert(max(Vreference-Xoptimum.getOptimalDesign)<1e-3,'openCOSSAN:Tutorial:TutorialCrossEntropy','Reference Solution not identified')