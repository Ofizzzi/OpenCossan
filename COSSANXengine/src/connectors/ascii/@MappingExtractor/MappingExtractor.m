classdef MappingExtractor < Extractor
    
    methods
        function Xobj  = MappingExtractor(varargin)
            
            %% 1. Processing Inputs
            
            % Process all the optional arguments and assign them the corresponding
            % default value if not passed as argument
            
            if rem(length(varargin),2)~=0
                error('The optional parameters must be passed an pair (name,value)');
            end
            
            %% Set options
            for k=1:2:length(varargin)
                switch lower(varargin{k})
                    case {'sdescription'}
                        Xobj.Sdescription=varargin{k+1};
                    case {'sfile'}
                        Xobj.Sfile=varargin{k+1};
                    case {'srelativepath'}
                        Xobj.Srelativepath=varargin{k+1};
                    case {'sworkingdirectory'}
                        Xobj.Sworkingdirectory = varargin{k + 1};    
                    case {'soutputname'}
                        Xobj.Soutputname=varargin{k+1};
                    otherwise
                        error('openCOSSAN:Mappingextractor','Field name not allowed');
                end
            end
            
            if isempty(Xobj.Sworkingdirectory)
                Xobj.Sworkingdirectory = OpenCossan.getCossanWorkingPath;
            end
            if isempty(Xobj.Soutputname)
                error('openCOSSAN:MappingExtractor','Soutputname not defined');
            end
            if isempty(Xobj.Sfile)
                error('openCOSSAN:MappingExtractor','No file name specified');
            end
            if exist([Xobj.Sworkingdirectory Xobj.Srelativepath filesep Xobj.Sfile],'file') ~= 2
                error(['COSSAN:MappingExtractor: Please make sure that the input file ' Xobj.Sfile ' exists']);
            end
        
        end %end constructor
        [Tout, LsuccessfullExtract] = extract(Xe,varargin)
    end
end
