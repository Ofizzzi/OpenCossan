function Xobj = initializeOptimizer(Xobj)
%INITIALIZEOPTIMIZER This method initializes the object Optimizer
%
% See Also: http://cossan.cfd.liv.ac.uk/wiki/initializeOptimizer@Optimizer
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

% Retrieve information of the caller
ST = dbstack(1);

ScallerDescription=['Start Simulation: ' ST(1).name '@' class(Xobj) ' ' Xobj.Sdescription];

% Initialize Timer
Xobj.initialLaptime = OpenCossan.setLaptime('Sdescription',ScallerDescription);

%% Initialize variables
if isempty(Xobj.SiterationFolder)
    Xobj.SiterationFolder=datestr(now,30);
end

Xobj.iIterations = 0;   % Number of iterations processed

end


