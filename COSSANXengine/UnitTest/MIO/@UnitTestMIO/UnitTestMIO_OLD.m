classdef UnitTestMIO < matlab.unittest.TestCase
    % This is a unit test fpr tje MIO connector
    %   Detailed explanation goes here
    
    properties
        Xinput;
        Xout;
        ExpOut;
        ActOut;
        ActOutDiff2;
        Samples;
        StestPath=fullfile(OpenCossan.getCossanRoot,'UnitTest', 'MIO');
        
    end
    
    methods (TestClassSetup)
        function AddPathAndCreateInputs(testCase) % the inputs must be created to be able to test the MIO
            testCase.addTeardown(@path, addpath(fullfile(OpenCossan.getCossanRoot,'UnitTest','MIO','PreparedInput'))); % adds the path for the prepared input files for each test and enables the removal of the path before and after all tests
            testCase.addTeardown(@path, addpath(fullfile(OpenCossan.getCossanRoot, 'UnitTest','MIO','PreparedOutput'))); %adds the path for the prepared output files and enables the removal of the path before and after all tests
            testCase.StestPath = fullfile(OpenCossan.getCossanRoot,'UnitTest', 'MIO'); %sets the test path for the StestPath variable
        end
    end
    methods (TestMethodSetup)
        function LoadKnownRandomVariables(testCase) % Loads the random variables of known value to allow for testing
              load Xinput  % loads the input to keep the values known to enable comparible testing
              testCase.Xinput = Xinput %creates input from known values
        end
    end
    
    methods (TestMethodTeardown)
        function CloseKnownRandomVariables(testCase) % removes the random variables after each test
              clear Xinput % this ensures that the values of the Xinput are the same for each test by forcing to reload
        end
    end
        
    methods (Test)
        function DisplayMethod(testCase) % Testing the display method
            Xm = Mio('Sdescription','Mio for unit Test','Spath',fullfile(testCase.StestPath,'FunctionForMio'),'Sfile','differenceStructure.m','Lfunction',true,'Liostructure',true,'Liomatrix',false,'Coutputnames',{'diff1';'diff2'},'Cinputnames',{'Xrv1';'Xrv2'});
            
            testCase.assertTrue(Xm.Lfunction,1);
            testCase.assertTrue(Xm.Liostructure,1);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'});
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'});
        end
          function MioWithStructureIO(testCase) % Tests  Mio with a structure i/o
            Xm=Mio('Sdescription','Mio for Unit Test', ...
                'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
                'Sfile','differenceStructure.m', ...
                'Lfunction',true, ...
                'Liostructure', true, ...
                'Liomatrix', false, ...
                'Coutputnames',{'diff1';'diff2'},...
                'Cinputnames',{'Xrv1';'Xrv2'});
            
            testCase.Xout = run(Xm,testCase.Xinput);
            testCase.ExpOut = load ('MioWithStructureIO.mat');
            testCase.ActOut = vertcat(testCase.Xout.Tvalues.diff1);
            testCase.ActOutDiff2 = vertcat(testCase.Xout.Tvalues.diff2);
            testCase.ActOut = cat(2,testCase.ActOut,testCase.ActOutDiff2) ;
            testCase.verifyEqual(testCase.ExpOut.MioWithStructureIO,testCase.ActOut);
            
          end
        
          
        function MioWithStructureUsingSampleValuesPassingInput(testCase) % Test Mio with a structure using sampled values, passing Input
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceStructure.m', ...
            'Lfunction',true, ...
            'Liostructure', true, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
        testCase.Xout = run(Xm,testCase.Xinput);
        
            testCase.ExpOut = load ('MioWithStructureUsingSampleValuesPassingInput.mat');  %loads the predetermined results from manual calculation
            testCase.ActOut = vertcat(testCase.Xout.Tvalues.diff1);
            testCase.ActOutDiff2 = vertcat(testCase.Xout.Tvalues.diff2);
            testCase.ActOut = cat(2,testCase.ActOut,testCase.ActOutDiff2) ;
            testCase.verifyEqual(testCase.ExpOut.D,testCase.ActOut);
%         
% %         testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
% %         Pout2 = run(Xm,testCase.Xinput);
% %         
        end
        function MioWithStructureUsingSampleValuesPassingSamples(testCase) % Test Mio with a structure using sampled values, passing Samples
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceStructure.m', ...
            'Lfunction',true, ...
            'Liostructure', true, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
% %         testCase.Xinput = sample(testCase.Xinput,'Nsamples',10); Not required due to prepared input
            testCase.Xout = run(Xm,testCase.Xinput.Xsamples);
        
            testCase.ExpOut = load ('MioWithStructureUsingSampleValuesPassingSamples.mat');  %loads the predetermined results from manual calculation
            testCase.ActOut = vertcat(testCase.Xout.Tvalues.diff1);
            testCase.ActOutDiff2 = vertcat(testCase.Xout.Tvalues.diff2);
            testCase.ActOut = cat(2,testCase.ActOut,testCase.ActOutDiff2) ;
            testCase.verifyEqual(testCase.ExpOut.D,testCase.ActOut);
          
        end
% %         function MioWithStructureUsingSampleValuesPassingStructure(testCase) % Test Mio with a structure using sampled values, passing Structure
% %             Xm=Mio('Sdescription','Mio for Unit Test', ...
% %             'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
% %             'Sfile','differenceStructure.m', ...
% %             'Lfunction',true, ...
% %             'Liostructure', true, ...
% %             'Liomatrix', false, ...
% %             'Coutputnames',{'diff1';'diff2'},...
% %             'Cinputnames',{'Xrv1';'Xrv2'});
% %         
% %         testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
% %         Pout2 = run(Xm,testCase.Xinput.getStructure);
% %         
% %             testCase.assertTrue(Xm.Lfunction,1);
% %             testCase.assertTrue(Xm.Liostructure,1);
% %             testCase.assertFalse(Xm.Liomatrix,0);
% %             testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
% %             testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
% %         end
% %         function MioWithStructureUsingSampleValuesPassingMatrix(testCase) % Test Mio with a structure using sampled values, passing a matrix
% %             Xm=Mio('Sdescription','Mio for Unit Test', ...
% %             'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
% %             'Sfile','differenceStructure.m', ...
% %             'Lfunction',true, ...
% %             'Liostructure', true, ...
% %             'Liomatrix', false, ...
% %             'Coutputnames',{'diff1';'diff2'},...
% %             'Cinputnames',{'Xrv1';'Xrv2'});
% %         
% %         testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
% %         Pout2 = run(Xm,testCase.Xinput.Xsamples.MsamplesPhysicalSpace);
% %         
% %             testCase.assertTrue(Xm.Lfunction,1);
% %             testCase.assertTrue(Xm.Liostructure,1);
% %             testCase.assertFalse(Xm.Liomatrix,0);
% %             testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
% %             testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
% %         end
        function MioWithMatrixIOPassingInput(testCase) %  Test Mio with a Matrix as Input and Output, passing a Input
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceMatrix.m', ...
            'Lfunction',true, ...
            'Liostructure', false, ...
            'Liomatrix', true, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
%         testCase.Xinput = sample(testCase.Xinput,'Nsamples',10); %no
%         longer needed as sample input created and used

        testCase.Xout = run(Xm,testCase.Xinput);  
        testCase.ExpOut = load ('MioWithMatrixIO.mat');
        testCase.ActOut = testCase.Xout.Mvalues;
        testCase.verifyEqual(testCase.ExpOut.MioWithMatrixIO,testCase.ActOut);
        end
        
        function MioWithMatrixIOPassingSample(testCase)  % Test Mio with a Matrix as Input and Output, passing a Samples
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceMatrix.m', ...
            'Lfunction',true, ...
            'Liostructure', false, ...
            'Liomatrix', true, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout3 = run(Xm,testCase.Xinput.Xsamples);
        
            testCase.assertTrue(Xm.Lfunction,1);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertTrue(Xm.Liomatrix,1);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioWithMAtrixInputOutputPassingStructure(testCase) % Test Mio with a Matrix as Input and Output, passing a structure
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceMatrix.m', ...
            'Lfunction',true, ...
            'Liostructure', false, ...
            'Liomatrix', true, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout3 = run(Xm,testCase.Xinput.getStructure);
        
            testCase.assertTrue(Xm.Lfunction,1);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertTrue(Xm.Liomatrix,1);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioWithMatrixInputOutputPassingMatrix(testCase)  % Testing Mio with a Matrix as Input and Output, passing a matrix
        Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceMatrix.m', ...
            'Lfunction',true, ...
            'Liostructure', false, ...
            'Liomatrix', true, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout3 = run(Xm,testCase.Xinput.Xsamples.MsamplesPhysicalSpace);
        
            testCase.assertTrue(Xm.Lfunction,1);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertTrue(Xm.Liomatrix,1);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioWithMultipleVectorsInputOutputPassingInput(testCase) % Testing Mio with multiple vectors as Input and Output, passing a Input
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceFunction.m', ...
            'Lfunction',true, ...
            'Liostructure', false, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout4 = run(Xm,testCase.Xinput);
        
            testCase.assertTrue(Xm.Lfunction,1);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioWithMultipleVectorsInputOutputPassingSamples(testCase) % Testing Mio with multiple vectors as Input and Output, passing a Samples
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceFunction.m', ...
            'Lfunction',true, ...
            'Liostructure', false, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout4 = run(Xm,testCase.Xinput.Xsamples);
        
            testCase.assertTrue(Xm.Lfunction,1);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioWithMultipleVectorsInputOutputPassingStructure(testCase) % Testing Mio with multiple vectors as Input and Output, passing a structure
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceFunction.m', ...
            'Lfunction',true, ...
            'Liostructure', false, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout4 = run(Xm,testCase.Xinput.getStructure);
        
            testCase.assertTrue(Xm.Lfunction,1);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioWithMultipleVectorsInputOutputPassingMatrix(testCase)  % Testing Mio with multiple vectors as Input and Output, passing a matrix
        Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'FunctionForMio'), ...
            'Sfile','differenceFunction.m', ...
            'Lfunction',true, ...
            'Liostructure', false, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout4 = run(Xm,testCase.Xinput.Xsamples.MsamplesPhysicalSpace);
        
            testCase.assertTrue(Xm.Lfunction,1);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
         function MioUsingScriptWithStructureInputOutputPassingInput(testCase)  % Testing Mio using a script with a structure as input and output, passing Input
           
             Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'ScriptForMio'), ...
            'Sfile','differenceStructure.m', ...
            'Lfunction',false, ...
            'Liostructure', true, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
       testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout5 = run(Xm,testCase.Xinput);
        
            testCase.assertFalse(Xm.Lfunction,0);
            testCase.assertTrue(Xm.Liostructure,1);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioWithScriptInputOutputPassingSamples(testCase) % Testing Mio using a script with a structure as input and output, passing Samples
        Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'ScriptForMio'), ...
            'Sfile','differenceStructure.m', ...
            'Lfunction',false, ...
            'Liostructure', true, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout5 = run(Xm,testCase.Xinput.Xsamples);
        
            testCase.assertFalse(Xm.Lfunction,0);
            testCase.assertTrue(Xm.Liostructure,1);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioUsingScriptWithStructureInputOutputPassingStructure(testCase) % Testing Mio using a script with a structure as input and output, passing structure
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'ScriptForMio'), ...
            'Sfile','differenceStructure.m', ...
            'Lfunction',false, ...
            'Liostructure', true, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout5 = run(Xm,testCase.Xinput.getStructure);
        
            testCase.assertFalse(Xm.Lfunction,0);
            testCase.assertTrue(Xm.Liostructure,1);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioUsingScriptWithStructureInputOutputPassingMatrix(testCase) % Testing Mio using a script with a structure as input and output, passing matrix
        Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'ScriptForMio'), ...
            'Sfile','differenceStructure.m', ...
            'Lfunction',false, ...
            'Liostructure', true, ...
            'Liomatrix', false, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout5 = run(Xm,testCase.Xinput.Xsamples.MsamplesPhysicalSpace);
        
            testCase.assertFalse(Xm.Lfunction,0);
            testCase.assertTrue(Xm.Liostructure,1);
            testCase.assertFalse(Xm.Liomatrix,0);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioUsingScriptWithMatrixInputOutputPassingInput(testCase) % Testing Mio using a script with a matrix as input and output, passing Input
            Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'ScriptForMio'), ...
            'Sfile','differenceMatrix.m', ...
            'Lfunction',false, ...
            'Liostructure', false, ...
            'Liomatrix', true, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout6 = run(Xm,testCase.Xinput);
        
            testCase.assertFalse(Xm.Lfunction,0);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertTrue(Xm.Liomatrix,1);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioUsingScriptWithMatrixInputOutputPassingSamples(testCase) % Testing Mio using a script with a matrix as input and output, passing Samples
        Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'ScriptForMio'), ...
            'Sfile','differenceMatrix.m', ...
            'Lfunction',false, ...
            'Liostructure', false, ...
            'Liomatrix', true, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout6 = run(Xm,testCase.Xinput.Xsamples);
        
            testCase.assertFalse(Xm.Lfunction,0);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertTrue(Xm.Liomatrix,1);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioUsingScriptWithMatrixInputOutputPassingStructure(testCase) % Testing Mio using a script with a matrix as input and output, passing structure
        Xm=Mio('Sdescription','Mio for Unit Test', ...
            'Spath',fullfile(testCase.StestPath,'ScriptForMio'), ...
            'Sfile','differenceMatrix.m', ...
            'Lfunction',false, ...
            'Liostructure', false, ...
            'Liomatrix', true, ...
            'Coutputnames',{'diff1';'diff2'},...
            'Cinputnames',{'Xrv1';'Xrv2'});
        testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
        Pout6 = run(Xm,testCase.Xinput.getStructure);
        
            testCase.assertFalse(Xm.Lfunction,0);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertTrue(Xm.Liomatrix,1);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
        function MioUsingScriptWithMatrixInputOutputPassingMatrix(testCase)  % Testing Mio using a script with a matrix as input and output, passing matrix
            Xm=Mio('Sdescription','Mio for Unit Test', ...
                'Spath',fullfile(testCase.StestPath,'ScriptForMio'), ...
                'Sfile','differenceMatrix.m', ...
                'Lfunction',false, ...
                'Liostructure', false, ...
                'Liomatrix', true, ...
                'Coutputnames',{'diff1';'diff2'},...
                'Cinputnames',{'Xrv1';'Xrv2'});
         testCase.Xinput = sample(testCase.Xinput,'Nsamples',10);
         Pout6 = run(Xm,testCase.Xinput.Xsamples.MsamplesPhysicalSpace);
         
            testCase.assertFalse(Xm.Lfunction,0);
            testCase.assertFalse(Xm.Liostructure,0);
            testCase.assertTrue(Xm.Liomatrix,1);
            testCase.assertEqual(Xm.Coutputnames',{'diff1';'diff2'})
            testCase.assertEqual(Xm.Cinputnames',{'Xrv1';'Xrv2'})
        end
%% These Tests are to ensure that the if the parameters are not correct the command fails
        function WrongInputsToConstructor(testCase)  % Checks that the command fails when the wrong input is passed to the constructor
               testCase.verifyError(@()Mio('Sdescription','Mio for Unit Test', ...
               'Spath',('FunctionForMio'), ...
               'Sfile','differenceStructure.m', ...
               'Sunexistingproperty',':-)', ...
               'Liostructure', true, ...
               'Liomatrix', false, ...
               'Coutputnames',{'diff1';'diff2'},...
               'Cinputnames',{'Xrv1';'Xrv2'}),'openCOSSAN:connectors:Mio')
        end
        function PassInputOfWrongTypeToConstructor(testCase) % Checks that the command fails due to wrong type passed to the constructor
           testCase.verifyError(@()Mio('Sdescription','Mio for Unit Test', ...
        'Spath',('FunctionForMio'), ...
        'Sfile','differenceStructure.m', ...
        'Lfunction',':-)', ...
        'Liostructure', true, ...
        'Liomatrix', false, ...
        'Coutputnames',{'diff1';'diff2'},...
        'Cinputnames',{'Xrv1';'Xrv2'}),'openCOSSAN:validateCOSSANInputs')
        end
        function GiveNonExistingFileToConstructor(testCase) % Checks that the command fails due to incorrect file specified to be passed to the constructor
           testCase.verifyError(@()Mio('Sdescription','Mio for Unit Test', ...
        'Spath',('FunctionForMio'), ...
        'Sfile','thisfiledoesntexist.m', ...
        'Lfunction',true, ...
        'Liostructure', true, ...
        'Liomatrix', false, ...
        'Coutputnames',{'diff1';'diff2'},...
        'Cinputnames',{'Xrv1';'Xrv2'}),'openCOSSAN:Mio')
        end

    end
end

