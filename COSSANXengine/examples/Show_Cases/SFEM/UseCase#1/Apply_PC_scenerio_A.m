%% Updated by HMP 14-Oct-2010

% example for Perturbation method : Building Model
% 3rd party solver : NASTRAN

%% Create the probabilistic model

% define the RVs
RVF1=RandomVariable('Sdistribution','normal', 'mean',1500,'std',150); 
RVF2=RandomVariable('Sdistribution','normal', 'mean',2500,'std',250); 
RVF3=RandomVariable('Sdistribution','normal', 'mean',2500,'std',250); 
RVF4=RandomVariable('Sdistribution','normal', 'mean',2500,'std',250); 
RVF5=RandomVariable('Sdistribution','normal', 'mean',2500,'std',250); 

RVKEE6=RandomVariable('Sdistribution','normal', 'mean',3.5e10,'std',3.5e9); 
RVKEE7=RandomVariable('Sdistribution','normal', 'mean',5e9,'std',5e8);

Xrvs1 = RandomVariableSet('Cmembers',{'RVF1','RVF2','RVF3','RVF4','RVF5','RVKEE6','RVKEE7'}); 
Xinp1 = Input('Sdescription','Xinput object');       
Xinp1 = add(Xinp1,Xrvs1);

%% Construct the Model

test_con   = Connector('Stype','nastran_x86_64','Smaininputfile','dummy');
test_eval  = Evaluator('Xconnector',test_con);
test_model = Model('Xevaluator',test_eval,'xinput',Xinp1);

%% Perform SFEM Analysis

Sdirectory = pwd;
test = SfemPolynomialChaos('Xmodel',test_model,'Sinputfile',[Sdirectory filesep 'BUILDING_A.dat'],...
                     'CdensityRVs',{'RVF1','RVF2','RVF3','RVF4','RVF5'},...
                     'CyoungsmodulusRVs',{'RVKEE6','RVKEE7'});
Xout = test.performAnalysis;    

getResponse(Xout,'Sresponse','max')                      
