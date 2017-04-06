%% Tutorial Extractor
% This tutorial shows how to create an Extractor object and to use the
% extract method. For this purpose, a dummy textfile called 'outputfile.txt'
% is used.
%
%
% See Also: http://cossan.co.uk/wiki/index.php/extract@Extractor
%
% $Copyright~2006-2017,~COSSAN~Working~Group$
% $Author: Edoardo Patelli$

%
% =====================================================================
% This file is part of openCOSSAN.  The open general purpose matlab
% toolbox for numerical analysis, risk and uncertainty quantification.
%
% openCOSSAN is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License.
%
% openCOSSAN is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with openCOSSAN.  If not, see <http://www.gnu.org/licenses/>.
% =====================================================================

%% Create extractor
% This tutorial will use a tipical FE output file to test the
% Extractor object. 
%
% The file used a example (outputfile.txt) is very simple but it covers
% different possible scenarios.

SpathName=fullfile(OpenCossan.getCossanRoot,'examples','Tutorials','CossanObjects','Connector');

% The Extractor object is constructed using Response Objects. These objects
% extract a single quantify from the file specified in the Extractor
% object. If 2 variables need to be extracted, 2 Response objects need to
% be defined. If the quantity of interest are extracted from different
% files, different Extractors are required. 

% The first response object Xresp1 read the value at column 1 row 3 from
% the beginning of the file specified in the Extractor and store it in the
% variable Out1. The extraction is repeated twice (i.e. 2 numbers will
% be extracted).
% The results are store as a Dataseries 

Xresp1 = Response('Sname', 'Out1', ...
             'Sfieldformat', '%d', ...
             'Clookoutfor',{}, ...
             'Svarname','', ...
             'Ncolnum',1, ...
             'Nrownum',3, ...
             'Sregexpression', '', ...
             'Nrepeat',2);

% The second response stores in a variable Out2 (Dataseries), 4 numerical
% values read from two lines after the end of response Out1 (i.e. from row number 7). 
%
Xresp2 = Response('Sname','Out2',...
                  'Sfieldformat','%3f%3f%3f%3f',...
                  'Svarname','Out1','Nrownum',2);
              
% The third response read the value from the table after two lines from the
% string 'This might be a header'. The all the values of the table are
% extracted until a empty line or the end of file is encountered. 
Xresp3 = Response('Sname', 'Out3', ...
             'Sfieldformat', '%i%e', ...
             'Clookoutfor',{'This might be a header'}, ...
             'Ncolnum',1,'Nrownum',2, ...
             'Nrepeat',Inf, 'VcoordIndex',1,'CSindexName',{'Time'});

% The 4 response extract a matrix starting from colum 3 and row 18 
Xresp4 = Response('Sname', 'Out4', ...
             'Sfieldformat', '%e%e%e', ...
             'Clookoutfor',{''}, ...
             'Svarname','', ...
             'Ncolnum',3, ...
             'Nrownum',18, ...
             'Nrepeat',2);
         
% The 5 response extract the third number stored at row 18 
Xresp5 = Response('Sname', 'Out5', ...
             'Sfieldformat', '%*e%*e%e', ...
             'Nrownum',13);
         
         
% Add Response to the Extractor object and define the file name
Xe=Extractor('Sdescription','Extractor for the tutorial', ...
             'Sworkingdirectory',SpathName, ...
             'Srelativepath','./', ... % this is the directory where the input and output are contained
             'Sfile','outputfile.txt',...
             'CXresponse',{Xresp1 Xresp2 Xresp3 Xresp4 Xresp5});

display(Xe)

%% use REMOVE method to remove unnecessary responses
Xe=Xe.remove('Out3'); 
display(Xe)

% And use ADD to add a response
Xe=Xe.add('Xresponse',Xresp3); 
display(Xe)


%% Extract the quantities of interest
% The method extract of Extractor does this for you. 
Tout=extract(Xe) 

%% Validate output
Vreference= [10 11 12 13];
assert(max(abs(Tout.Out2.Vdata-Vreference))<eps,...
    'CossanX:Tutorials:TutorialEvaluator','Reference Solution does not match.')

assert(max(abs(Tout.Out5-70000))<eps,...
    'CossanX:Tutorials:TutorialEvaluator','Reference Solution does not match.')
