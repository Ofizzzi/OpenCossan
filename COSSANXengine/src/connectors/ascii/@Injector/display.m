function display(Xi)
%DISPLAY  Displays the object injector
%
%
%   Example: DISPLAY(Xi) will output the summary of the injector object
% =========================================================================
% Author: Edoardo Patelli
% Institute for Risk and Uncertainty, University of Liverpool, UK
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

%% 1.   Output to Screen
% 1.1.   Name and description
OpenCossan.cossanDisp(' ');
OpenCossan.cossanDisp('===================================================================',1);
OpenCossan.cossanDisp([' Injector Object  -  Name: ' inputname(1)],1);
OpenCossan.cossanDisp([' Description: ' Xi.Sdescription ] ,1);
OpenCossan.cossanDisp('===================================================================',1);

if strcmp(Xi.Sdescription,'Empty injector')
    return
end

% 1.2.   main paramenters
OpenCossan.cossanDisp(' ',1);
OpenCossan.cossanDisp([' Number of Input variables: ' num2str(Xi.Nvariable) ],1);
OpenCossan.cossanDisp([' ASCII file: ' Xi.Srelativepath Xi.Sfile ],1);

% 1.3.  Response details
for i=1:length(Xi.Xidentifier)
    OpenCossan.cossanDisp(['-->   Value #' num2str(i)],1);
    display(Xi.Xidentifier(i))
end


