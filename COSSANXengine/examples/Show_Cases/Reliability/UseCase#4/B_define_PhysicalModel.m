%
% Building under wind loading - define Physical Model
%
% In this example, the variation of the stresses of a structural model with
% random model parameters are computed by means of MonteCarlo simulation.
%
% The structural model comprises a 6-story building under a lateral wind 
% excitation. The load is modeled with deterministic constant forces acting 
% on a side of the building, with the pressure of the wind, and thus the
% acting force, increasing as the height of the building according to a 
% power increase.
% The material and geometric parameters of the columns, stairs ceiling and 
% floors of the building are modeled with independent random variables.
% 500 MonteCarlo simulations are carried out. 
%
% =========================================================================
% COSSAN - COmputational Stochastic Structural Analysis
% IfM, Chair of Engineering Mechanics, LFU Innsbruck, A
% Copyright 1993-2009 IfM
% =========================================================================


%% FE Input files
% 
% The Injector create a link between an input file(s) required by the 3rd
% party software and the COSSAN Input object.  
% The realizations of the uncertain parameters (i.e. samples) generate in
% COSSAN-X are inserted in the input file(s) at the execution time.

% TODO: what are the identifiers? We should say first that the input file
% of the model is required. 

% Copy input file with the indentifiers
% copyfile('../Auxiliary files/Building.cossan','./')

Xinj = Injector('Sscanfilename','Building.cossan',... %name of the file with identifiers
    'Sfile','Building.inp'...%name of the input file, i.e. once the values have been injected
    );

% The position of the variable are stored into the Xinj Injector object

% The format of the variable is the following: 
% <cossan name="sectionX_Col1_Floor_1" original="0.4" format="%10.3e" />
% name: is the name of the variable in the Input object
% format: format use to store the variable in the input file
%         (see fscanf for more details about the format string
%          ordinary characters and/or conversion specifications). 
% original: original value of the parameter 


%% Define quantity of Interest

% The following cell arrays contain the number of the beam elements
% composing the columns of each floor, as seen in the output file of the
% deterministic simulation (Building.rpt).

col_floor{1} = [ 9044, 9045, 9046, 9047, 9048, 9049, 9050, 9051, 9052, 9053, 9054, 9055,....
    9056, 9057, 9058, 9059, 9060, 9061, 9062, 9063, 9092, 9093, 9094, 9095,...
    9096, 9097, 9098, 9099, 9072, 9073, 9074, 9075, 9064, 9065, 9066, 9067,...
    9140, 9141, 9142, 9143, 9144, 9145, 9146, 9147, 9076, 9077, 9078, 9079,....
    9068, 9069, 9070, 9071, 9084, 9085, 9086, 9087, 9088, 9089, 9090, 9091,...
    9080, 9081, 9082, 9083 ];

col_floor{2} = [ 2060, 2061, 2062, 2063, 2064, 2065, 2066, 2067, 2068, 2069, 2070, 2071,...
    2072, 2073, 2074, 2075, 2076, 2077, 2078, 2079, 2108, 2109, 2110, 2111,...
    2112, 2113, 2114, 2115, 2088, 2089, 2090, 2091, 2080, 2081, 2082, 2083,...
    9100, 9101, 9102, 9103, 9104, 9105, 9106, 9107, 2092, 2093, 2094, 2095,...
    2084, 2085, 2086, 2087, 2100, 2101, 2102, 2103, 2104, 2105, 2106, 2107,...
    2096, 2097, 2098, 2099 ];

col_floor{3} = [ 2142, 2155, 2165, 2171, 2139, 2153, 2163, 2170, 2137, 2151, 2161, 2169,...
    2136, 2150, 2160, 2168, 2130, 2144, 2158, 2167, 2129, 2143, 2156, 2166,...
    2127, 2140, 2154, 2164, 2126, 2138, 2152, 2162, 2122, 2133, 2147, 2159,...
    9108, 9109, 9110, 9111, 9112, 9113, 9114, 9115, 2120, 2128, 2141, 2157,...
    2119, 2125, 2135, 2149, 2118, 2124, 2134, 2148, 2117, 2123, 2132, 2146,...
    2116, 2121, 2131, 2145];

col_floor{4} = [  2198, 2211, 2221, 2227, 2195, 2209, 2219, 2226, 2193, 2207, 2217, 2225,...
    2192, 2206, 2216, 2224, 2186, 2200, 2214, 2223, 2185, 2199, 2212, 2222,...
    2183, 2196, 2210, 2220, 2182, 2194, 2208, 2218, 2178, 2189, 2203, 2215,...
    9116, 9117, 9118, 9119, 9120, 9121, 9122, 9123, 2176, 2184, 2197, 2213,...
    2175, 2181, 2191, 2205, 2174, 2180, 2190, 2204, 2173, 2179, 2188, 2202,...
    2172, 2177, 2187, 2201];

col_floor{5} = [ 2254, 2267, 2277, 2283, 2251, 2265, 2275, 2282, 2249, 2263, 2273, 2281,...
    2248, 2262, 2272, 2280, 2242, 2256, 2270, 2279, 2241, 2255, 2268, 2278,...
    2239, 2252, 2266, 2276, 2238, 2250, 2264, 2274, 2234, 2245, 2259, 2271,...
    9124, 9125, 9126, 9127, 9128, 9129, 9130, 9131, 2232, 2240, 2253, 2269,...
    2231, 2237, 2247, 2261, 2230, 2236, 2246, 2260, 2229, 2235, 2244, 2258,...
    2228, 2233, 2243, 2257];

col_floor{6} = [ 2310, 2323, 2333, 2339, 2307, 2321, 2331, 2338, 2305, 2319, 2329, 2337,...
    2304, 2318, 2328, 2336, 2298, 2312, 2326, 2335, 2297, 2311, 2324, 2334,...
    2295, 2308, 2322, 2332, 2294, 2306, 2320, 2330, 2290, 2301, 2315, 2327,...
    9132, 9133, 9134, 9135, 9136, 9137, 9138, 9139, 2288, 2296, 2309, 2325,...
    2287, 2293, 2303, 2317, 2286, 2292, 2302, 2316, 2285, 2291, 2300, 2314,...
    2284, 2289, 2299, 2313];
    
% Create an array of Response objects.
% TODO: explain way?
% Each Response link a value contained
% in the ASCII output file to an Output value of COSSAN. In this array, the
% name of the output is automatically set to C<number_of_element>, linking
% it to the value of the strees contained in the output file Building.rpt.

Xresp1= Response('Clookoutfor',{' 2286 '},... % string to be searched in the output file to identify the position of the value
    'Sfieldformat','%e',... % format of the output. In this case, a four-dimesional array is extracted from the output file and associated to the output
    'Sname','C2286_1',... % name of the associated COSSAN output
    'Nrownum',0,'Ncolnum',17.... % position of the output (row and column), relative to the Clookoutfor string
    ); 

Xresp2= Response('Svarname','C2286_1',... % string to be searched in the output file to identify the position of the value
    'Sfieldformat','%e',... % format of the output. In this case, a four-dimesional array is extracted from the output file and associated to the output
    'Sname','C2286_2',... % name of the associated COSSAN output
    'Nrownum',0,'Ncolnum',37.... % position of the output (row and column), relative to the Clookoutfor string
    ); 

Xresp3= Response('Svarname','C2286_1',... % string to be searched in the output file to identify the position of the value
    'Sfieldformat','%e',... % format of the output. In this case, a four-dimesional array is extracted from the output file and associated to the output
    'Sname','C2286_3',... % name of the associated COSSAN output
    'Nrownum',0,'Ncolnum',53.... % position of the output (row and column), relative to the Clookoutfor string
    ); 

Xresp4= Response('Svarname','C2286_1',... % string to be searched in the output file to identify the position of the value
    'Sfieldformat','%e',... % format of the output. In this case, a four-dimesional array is extracted from the output file and associated to the output
    'Sname','C2286_4',... % name of the associated COSSAN output
    'Nrownum',0,'Ncolnum',69.... % position of the output (row and column), relative to the Clookoutfor string
    ); 

% The Extractor links the COSSAN outputs to an ASCII output file.
Xe = Extractor('Sfile', 'Building.rpt', 'Srelativepath', './','Xresponse', [Xresp1 Xresp2 Xresp3 Xresp4]);


%% Connect COSSAN-X with 3rd party software

%% CREATE CONNECTOR
Xc=Connector('Spredefinedtype','Abaqus','Smaininputfile','Building.inp',...
             'Caddfiles',{'generate_report.py'});
         
Xc.SpostExecutionCommand = [Xc.Ssolverbinary ' cae noGUI=generate_report.py'];

% add the Injector object to the Connector object 
Xc = add(Xc, Xinj);

% add the Extractor object to the Connector object
Xc = add(Xc,Xe);


