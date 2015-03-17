function [nodes,edges] = getNodesAndEdgesFromFile(input_filename)
% Conversion to script of Tak's model.
% GUI elements were removed.
%


%% Inputs

disp(['Loading data from file: ' input_filename]);


%% Tak's code:

addpath('/opt/ibm/ILOG/CPLEX_Studio126/cplex/matlab/');
addpath('../matlab');

% Dynamic: load mongodb java driver
javaaddpath('../mongodb/mongo-java-driver.jar');
% Static:
%   To load mongodb java driver a file called 'javaclasspath.txt' must
%   exist on the current directory with the content:
%   /path/to/mongo-java-driver.jar


%%

% Node
[handles.numCity,handles.txtCity] = xlsread(input_filename,'City','A3:AZ1000'); % City
[handles.numDesal,handles.txtDesal] = xlsread(input_filename,'Desal','A3:AZ1000'); % Desal
[handles.numDesalCandid,handles.txtDesalCandid] = xlsread(input_filename,'Desal_Candid','A3:AZ1000'); % Desal Candidate
[handles.numPower,handles.txtPower] = xlsread(input_filename,'Power','A3:AZ1000'); % Power

% Edge
[handles.numPipeline,handles.txtPipeline] = xlsread(input_filename,'Pipeline','A3:AZ1000'); % Pipeline
[handles.numPipelineCandid,handles.txtPipelineCandid] = xlsread(input_filename,'Pipeline_Candid','A3:AZ1000'); % Pipeline Candidate
[handles.numPowerline,handles.txtPowerline] = xlsread(input_filename,'Powerline','A3:AZ1000'); % Powerline


% Flow Variables
%   1: feed water [m^3/day]
%   2: potable water [m^3/day]
%   3: non-potable water [m^3/day]
%   4: waste water [m^3/day]
%   5: power resource [MW]
%   6: electricity [MW]
handles.flow = {'feed water';
                'potable water';
                'non-potable water';
                'waste water';
                'power resource';
                'electricity'};
handles.v = size(handles.flow,1); % number of flow variables

% Decision Binary Variables
%   1: water
%   2: power
handles.binary = {'water';
                  'power'};
% handles.vw = [1 0;1 0;1 0;1 0;0 1;0 1]; % mapping matrix from flow to binary
handles.w = size(handles.binary,1); % number of binary variables

% Key performance indicators (KPI)
%   1: total CAPEX [USD/year]
%   2: total OPEX [USD/year]
%   3: total CO2 emission [kg/day]
%   4: total potable water produced [m^3/day]
%   5: total electricity produced [kWh/day]
%   6: ...
handles.KPI = {'CAPEX'
               'OPEX'
               'CO2'
               'potable water';
               'electricity'};

% Objective Function Weight
% handles.W = zeros(size(handles.KPI));
% handles.W(index(handles.KPI,'CAPEX')) = 1;
% handles.W(index(handles.KPI,'OPEX')) = 1;
% handles.W(index(handles.KPI,'CO2')) = 0;
% handles.W(index(handles.KPI,'potable water')) = 0;
% handles.W(index(handles.KPI,'electricity')) = 0;

% Node Set Definition
handles.setNode = [];
[handles.setNode] = setupExistingNodes(handles.setNode,handles.numCity,handles.txtCity,handles.numDesal,handles.txtDesal,handles.numPower,handles.txtPower,handles.flow,handles.v); % existing nodes
[handles.setNode] = setupCandidateNodes(handles.setNode,handles.numDesalCandid,handles.txtDesalCandid,handles.flow,handles.v); % candidate nodes


% Edge Set Definition
handles.setEdge = [];
[handles.setEdge] = setupExistingLoops(handles.setNode,handles.setEdge,handles.numCity,handles.txtCity,handles.numDesal,handles.txtDesal,handles.numPower,handles.txtPower,handles.flow,handles.v,handles.w,handles.KPI); % existing resource processing loops
[handles.setEdge] = setupCandidateLoops(handles.setNode,handles.setEdge,handles.numDesalCandid,handles.txtDesalCandid,handles.flow,handles.v,handles.w,handles.KPI); % candidate resource processing loops
[handles.setEdge] = setupExistingEdges(handles.setNode,handles.setEdge,handles.numPipeline,handles.txtPipeline,handles.numPowerline,handles.txtPowerline,handles.flow,handles.v,handles.binary,handles.w,handles.KPI); % existing pipelines and powerlines
[handles.setEdge] = setupCandidateEdges(handles.setNode,handles.setEdge,handles.numPipelineCandid,handles.txtPipelineCandid,handles.flow,handles.v,handles.binary,handles.w,handles.KPI); % candidate pipelines

% Result:
nodes = handles.setNode;
edges = handles.setEdge;




end