function display(Xobj)
%DISPLAY Show the content of the object OpenCossan
%
% See also: https://cossan.co.uk/wiki/index.php/@OpenCossan

%
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

OpenCossan.cossanDisp('===================================================================',2);
OpenCossan.cossanDisp([' Analysis Object  -  Description: ' Xobj.Sdescription],1);
OpenCossan.cossanDisp('===================================================================',2);

OpenCossan.cossanDisp(['* Project Name: ' Xobj.SprojectName],3);
OpenCossan.cossanDisp(['* Analysis Name: ' Xobj.SanalysisName],3);

OpenCossan.cossanDisp('-------------------------------------------------------------',3);

OpenCossan.cossanDisp(['* Random Number Generator: ' Xobj.SrandomNumberAlgorithm ' seed: ' num2str(Xobj.Nseed)],3);

if OpenCossan.getVerbosityLevel>3
    disp(Xobj.XrandomStream)
end

end

