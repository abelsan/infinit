function [output,status] = infinit_pre(inputs)
% Conversion to script of Tak's model.
% GUI elements were removed.
%
% inputs structure members:
%   cost
%   CO2
%   time_limit
%   optimality_gap
%   input_filename
%   filename
%


result.date_start = datestr(now); % Start date

%% Inputs

handles.sliderCost = inputs.cost;
handles.sliderCO2 = inputs.CO2;

timelimit = inputs.time_limit;
parameter2009 = inputs.optimality_gap;

filename = inputs.input_filename;

disp(['Loading data from file: ' filename]);


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
[handles.numCity,handles.txtCity] = xlsread(filename,'City','A3:AZ1000'); % City
[handles.numDesal,handles.txtDesal] = xlsread(filename,'Desal','A3:AZ1000'); % Desal
[handles.numDesalCandid,handles.txtDesalCandid] = xlsread(filename,'Desal_Candid','A3:AZ1000'); % Desal Candidate
[handles.numPower,handles.txtPower] = xlsread(filename,'Power','A3:AZ1000'); % Power

% Edge
[handles.numPipeline,handles.txtPipeline] = xlsread(filename,'Pipeline','A3:AZ1000'); % Pipeline
[handles.numPipelineCandid,handles.txtPipelineCandid] = xlsread(filename,'Pipeline_Candid','A3:AZ1000'); % Pipeline Candidate
[handles.numPowerline,handles.txtPowerline] = xlsread(filename,'Powerline','A3:AZ1000'); % Powerline


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
handles.vw = [1 0;1 0;1 0;1 0;0 1;0 1]; % mapping matrix from flow to binary
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
handles.W = zeros(size(handles.KPI));
handles.W(index(handles.KPI,'CAPEX')) = 1;
handles.W(index(handles.KPI,'OPEX')) = 1;
handles.W(index(handles.KPI,'CO2')) = 0;
handles.W(index(handles.KPI,'potable water')) = 0;
handles.W(index(handles.KPI,'electricity')) = 0;


[handles.setNode,handles.setEdge] = getNodesAndEdgesFromFile(filename);
handles.N = size(handles.setNode,1); % number of nodes
handles.E = size(handles.setEdge,1); % number of edges


% INFINIT MILP Parameters
% setNode                           setEdge
%  1: node ID                        1: edge ID
%  2: node name                      2: edge name
%  3: node region                    3: edge type
%  4: node type                      4: origin & destination
%  5: coordinates                    5: objective function coefficient for flow: cx
%  6: supply/demand                  6: objective function coefficient for capacity expansion: cy
%  7: other important properties     7: objective function coefficient for edge usage: cz
%                                    8: requirement matrix for outflow: Ao
%                                    9: requirement matrix for inflow: Ai
%                                   10: transformation matrix: B
%                                   11: concurrency matrix for outflow: Co
%                                   12: concurrency matrix for inflow: Ci
%                                   13: lower bound for outflow: lo
%                                   14: lower bound for inflow: li
%                                   15: current capacity for outflow: uo
%                                   16: current capacity for inflow: ui
OD = handles.setEdge(:,4); % origin and destination of each edge
handles.cx = handles.setEdge(:,5);
handles.cy = handles.setEdge(:,6);
handles.cz = handles.setEdge(:,7);
Ao = handles.setEdge(:,8);
Ai = handles.setEdge(:,9);
bc = handles.setNode(:,6);
B = handles.setEdge(:,10);
Co = handles.setEdge(:,11);
Ci = handles.setEdge(:,12);
lo = handles.setEdge(:,13);
li = handles.setEdge(:,14);
uo = handles.setEdge(:,15);
ui = handles.setEdge(:,16);

%%

disp('Setup INFINIT.');

% [fall,f,Aineq,bineq,Aeq,beq,lb] = setupINFINIT(v,w,vw,W,N,E,OD,cx,cy,cz,Ao,Ai,bc,B,Co,Ci,lo,li,uo,ui);
[handles.fall,handles.f,handles.Aineq,handles.bineq,handles.Aeq,handles.beq,handles.lb] = setupINFINIT(handles.v,handles.w,handles.vw,handles.W,handles.N,handles.E,OD,handles.cx,handles.cy,handles.cz,Ao,Ai,bc,B,Co,Ci,lo,li,uo,ui);
xstr = repmat('C',1,2*handles.v);
ystr = repmat('C',1,2*handles.v);
zstr = repmat('B',1,handles.w);
handles.ctype = repmat([xstr ystr zstr],1,handles.E);

handles.generate = 1;
handles.network = 0;


%%

disp('Setup Weighted Objective Function');

% Normalizer
normCost = 6.7173; % 2010-2030
normCO2 = 11.9896; % 2010-2030
% normCost = 6.8368; % 2010-2030 twice pipeline CAPEX
% normCO2 = 24.5628; % 2010-2030 twice pipeline CAPEX

% Objective Function Weight
handles.W = zeros(size(handles.KPI));
handles.weightCost = handles.sliderCost/(handles.sliderCost+handles.sliderCO2);
handles.weightCO2 = 1-handles.weightCost;
e = 1e-6;
handles.W(index(handles.KPI,'CAPEX')) = handles.weightCost/normCost+e;
handles.W(index(handles.KPI,'OPEX')) = handles.weightCost/normCost+e;
handles.W(index(handles.KPI,'CO2')) = handles.weightCO2/normCO2+e;
handles.W(index(handles.KPI,'potable water')) = 0;
handles.W(index(handles.KPI,'electricity')) = 0;

[handles.fall,handles.f] = setupObjFun(handles.v,handles.w,handles.W,handles.E,handles.cx,handles.cy,handles.cz);

handles.setWeight = 1;



%%

disp('Running optimization');

% Options
options = cplexoptimset('cplex');
options.timelimit = timelimit ;
options.parameter2009 = parameter2009;



% MILP Solver (CPLEX)
% [x,J,exitflag,output] = cplexmilp(handles.f,handles.Aineq,handles.bineq,handles.Aeq,handles.beq,[],[],[],handles.lb,[],handles.ctype,[],options);
[x,~,~,output] = cplexmilp(handles.f,handles.Aineq,handles.bineq,handles.Aeq,handles.beq,[],[],[],handles.lb,[],handles.ctype,[],options);

disp('Presenting results');

%     handles.i = handles.i+1;
handles.i = 1;


handles.fx = handles.fall'*x;
handles.xyz = splitvw(x,handles.v,handles.w,handles.vw,handles.E);

if output.cplexstatus == 102
    handles.termination{handles.i} = ['Optimality Gap of ' num2str(options.parameter2009) '%'];
    disp(handles.termination{handles.i});
elseif output.cplexstatus == 107
    handles.termination{handles.i} = ['Time Limit of ' num2str(options.timelimit) ' sec'];
    disp(handles.termination{handles.i});
else
    handles.termination{handles.i} = 'Unknown';
    disp(handles.termination{handles.i});
end
handles.CAPEX(handles.i) = handles.fx(index(handles.KPI,'CAPEX'))/10^6;
handles.OPEX(handles.i) = handles.fx(index(handles.KPI,'OPEX'))/10^6;
handles.cost(handles.i) = handles.CAPEX(handles.i)+handles.OPEX(handles.i);
handles.CO2(handles.i) = handles.fx(index(handles.KPI,'CO2'))/10^9;
handles.potable(handles.i) = handles.fx(index(handles.KPI,'potable water'))*365/10^6;
totalDemandWater = 0; % [m^3/day]
for i = 1:size(handles.setNode,1)
    totalDemandWater = totalDemandWater+abs(handles.setNode{i,6}(index(handles.flow,'potable water')));
end
handles.totalLossWater(handles.i) = (handles.fx(index(handles.KPI,'potable water'))-totalDemandWater)/handles.fx(index(handles.KPI,'potable water'))*100; % [%]
handles.electricity(handles.i) = handles.fx(index(handles.KPI,'electricity'))*365/10^6;

indicators.cost = handles.cost(handles.i); % total cost
indicators.CAPEX = handles.CAPEX(handles.i); % total CAPEX
indicators.OPEX = handles.OPEX(handles.i); % total OPEX
indicators.CO2 = handles.CO2(handles.i); % total CO2 emission
indicators.potable = handles.potable(handles.i); % total potable water production
indicators.totalLossWater = handles.totalLossWater(handles.i); % total water loss in pipeline
indicators.electricity = handles.electricity(handles.i); % total electricity generation

disp('Formating outputs');

% Simulation Parameters
result.inputs.filename = filename;
result.inputs.cost = handles.sliderCost;
result.inputs.CO2 = handles.sliderCO2;
result.inputs.timelimit = timelimit;
result.inputs.optimality_gap = parameter2009;
result.inputs.edges = getInitialEdges(handles.setNode,handles.setEdge)';
result.inputs.nodes = getInitialNodes(handles.setNode)';

% Optimization result
result.outputs.cplex.cplexstatus = output.cplexstatus;
result.outputs.cplex.cplexstatusmsg = handles.termination{handles.i};
result.outputs.indicators = indicators;
result.outputs.nodes = getResultNodes(handles.setNode,handles.setEdge,handles.flow,handles.xyz)'; % Data is read in column-wise order.
result.outputs.edges = getResultEdges(handles.setNode,handles.setEdge,handles.xyz)'; % Data is read in column-wise order.


% TODO: Define the meaning of status output, i.e. status=1 means OK, etc...
status = 1;
output = result;
disp('Done.');

