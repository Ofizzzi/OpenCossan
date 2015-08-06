function display(Xobj)
%DISPLAY  Displays the object 
% ==================================================================
% COSSAN-X - The next generation of the computational stochastic analysis
% University of Innsbruck, Copyright 1993-2011 IfM
% ==================================================================

%% Name and description
OpenCossan.cossanDisp('===================================================================',3);
OpenCossan.cossanDisp([ class(Xobj) ' object  -  Description: ' Xobj.Sdescription ],1);
OpenCossan.cossanDisp('===================================================================',3);
OpenCossan.cossanDisp(['Analysis type            : '  Xobj.Sanalysis ' Analysis'],1);
OpenCossan.cossanDisp(['Input File               : '  Xobj.Sinputfile ],1);
OpenCossan.cossanDisp(['Implementation type      : '  Xobj.Simplementation ],1);
return
