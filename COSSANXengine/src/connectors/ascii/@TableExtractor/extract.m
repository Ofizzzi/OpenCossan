function [Tout, LsuccessfullExtract] = extract(Xobj,varargin)
%EXTRACT This method read a table and returns a structures with Dataseries
%
% See Also: TableExtractor
%
% Author: Edoardo Patelli
% COSSAN Working Group
% email address: openengine@cossan.co.uk
% Website: http://www.cossan.co.uk

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

%% 1. Processing Inputs

OpenCossan.validateCossanInputs(varargin{:});
for iopt=1:2:length(varargin)
    switch lower(varargin{iopt})
        case {'nsimulation'}
            Nsimulation = varargin{iopt+1};
        otherwise
            error('openCOSSAN:TableExtractor:extractWrongInputArgument',...
                ['Optional parameter ' varargin{iopt} ' not allowed']);
            
    end
end

LsuccessfullExtract = true;

%% Access to the output file
Sfile = fullfile(Xobj.Sworkingdirectory, Xobj.Srelativepath, Xobj.Sfile);

OpenCossan.cossanDisp(['[OpenCossan.TableExtractor.extract] Reading file : ' Xobj.Sworkingdirectory Xobj.Srelativepath Xobj.Sfile],4 )

% Check if the file exists, otherwise return NaN
if ~exist(Sfile,'file')
    OpenCossan.cossanDisp('[OpenCossan.TableExtractor.extract] File does NOT exist!',2)

    LsuccessfullExtract = false;
    for ioutput=1:length(Xobj.Coutputnames)
        Tout.(Xobj.Coutputnames{ioutput})=NaN;
    end
    return,
end

%% Identify number of headers
if ~isempty(Xobj.SheaderIdentifier)
    
    Xobj.Nheaderlines=0;
    
    fileID=fopen(Sfile,'r');
    Sline=fgetl(fileID);
    while  strncmp(Sline,Xobj.SheaderIdentifier,length(Xobj.SheaderIdentifier))
        Xobj.Nheaderlines=Xobj.Nheaderlines+1;
        Sline=fgetl(fileID);
    end
    % Close the file
    fclose(fileID);
end

%% Do import
if ~isempty(Xobj.Nheaderlines)
   Textract = readtable(Sfile,'HeaderLines',Xobj.Nheaderlines,...
       ... just comment the following line to revert to comma separated values
       'Delimiter',' ','ReadVariableNames',false); % TODO (mda): The delimiter type has to be present in the object otherwise it assumes that is a comma!
else
   Textract = readtable(Sfile,...
       ... just comment the following line to revert to comma separated values
       'Delimiter',' ','ReadVariableNames',false); % TODO (mda): The delimiter type has to be present in the object otherwise it assumes that is a comma!
end

for n=1:length(Xobj.Coutputnames)
    TableData=Textract(Xobj.ClinePosition{n},Xobj.CcolumnPosition{n});
    Tout.(Xobj.Coutputnames{n})=Dataseries('Mdata',table2array(TableData)');
end

% 
% if Xobj.LextractColumns
%     % Extract only specified columns
%     Ncolumns=length(Xobj.CcolumnPosition);
%     Mdata=zeros(size(Mextract.data,1),Ncolumns);
%     
%     for icol=1:Ncolumns
%         Mdata(:,icol)=Mextract.data(:,Xobj.CcolumnPosition{icol});
%     end
% else
%     Nlines=length(Xobj.ClinePosition);
%     Mdata=zeros(size(Mextract.data,2),Nlines);
%     for irow=1:length(Xobj.ClinePosition)
%         Mdata(:,irow)=Mextract.data(:,Xobj.ClinePosition{irow});
%     end
% end
% 
% % Check what to extract
% if isempty(Xobj.CcolumnPosition)
%     if isempty(Xobj.ClinePosition)
%         % There should be only 1 (one) output
%         Tout.(Xobj.Coutputnames{1}).Mcoord=Dataseries('Mdata',Mextract.data');
%     else
%         for n=1:length(Xobj.Coutputnames)
%             Tout.(Xobj.Coutputnames{n}).Mcoord=Dataseries('Mdata',...
%                 Mextract.data(Xobj.ClinePosition{n},:)');
%         end
%     end
% else
%     if isempty(Xobj.ClinePosition)
%         for n=1:length(Xobj.Coutputnames)
%             Tout.(Xobj.Coutputnames{n}).Mcoord=Dataseries('Mdata',...
%                 Mextract.data(:,Xobj.CcolumnPosition{n})');
%         end
%     else
%         for n=1:length(Xobj.Coutputnames)
%             Tout.(Xobj.Coutputnames{n}).Mcoord=Dataseries('Mdata',...
%                 Mextract.data(Xobj.ClinePosition{n},Xobj.CcolumnPosition{n})');
%         end
%     end
% end

% Add coordinate to the Dataseries
if ~isempty(Xobj.NcoordinateColumn)
    for n=1:length(Xobj.Coutputnames)
        TableCoord=Textract(Xobj.ClinePosition{n},Xobj.NcoordinateColumn);
        Tout.(Xobj.Coutputnames{n}).Mcoord=table2array(TableCoord)';
    end
end



OpenCossan.cossanDisp(['[COSSAN-X:TableExtractor.extract] Response ' Xobj.Coutputnames{:} ': ' ],4 )

