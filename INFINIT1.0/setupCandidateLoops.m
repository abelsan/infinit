%% Setting Up Candidate Loops
% Inputs
%   Set of Nodes: setNode
%   Set of Edges: setEdge
%   Raw Data
%   Flow Vector: flow
%   Size of Flow Vector: v
%   Size of Binary Vector: w
%   Key Performance Indicators: KPI
% Outputs
%   Set of Edges: setEdge

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [setEdge] = setupCandidateLoops(setNode,setEdge,numDesalCandid,txtDesalCandid,flow,v,w,KPI)

%% Settings
listID = cell2mat(setNode(:,1));

%% Defining Serial Edges
%  1: edge ID
%  2: edge name
%  3: edge type
%  4: origin & destination
%  5: objective function coefficient for flow: cx
%  6: objective function coefficient for capacity expansion: cy
%  7: objective function coefficient for edge usage: cz
%  8: requirement matrix for outflow: Ao
%  9: requirement matrix for inflow: Ai
% 10: transformation matrix: B
% 11: concurrency matrix for outflow: Co
% 12: concurrency matrix for inflow: Ci
% 13: lower bound for outflow: lo
% 14: lower bound for inflow: li
% 15: current capacity for outflow: uo
% 16: current capacity for inflow: ui

%% Desal Plant
% Desalination: feed water -> potable water
% Electricity Production: power resource -> electricity
% Text
%   A1: Desal Plant
%   Administration
%      B2: Region
%      C3: Abbr.
%   D4: Feed Water
%   E5: Technology
%   F6: Fuel
% Number
%   G1: ID [-]
% ----------
%   H2: Latitude [deg N]
%   I3: Longitude [deg E]
%   J4: Elevation [m]
% ----------
%   K5: Online Year
%   L6: Online?
% ----------
%   M7: Water Capacity [m^3/day]
%   N8: Water Capacity Online [m^3/day]
%   O9: Power Consumption [kWh/m^3]
%  P10: Capacity Expansion Cost [USD/m^3]
%  Q11: Operation Cost [USD/m^3]
%  R12: CO2 Emission [kg/m^3]
% ----------
%  S13: Power Capacity [MW]
%  T14: Power Capacity Online [MW]
%  U15: Capacity Expansion Cost [USD/kWh]
%  V16: Operation Cost [USD/kWh]
%  W17: CO2 Emission [kg/kWh]
% ----------
%  X18: Lifetime [year]
%  Y19: Est. Project Cost [USD]
%  Z20: Annum Capital Cost [USD/year]
nDesalCandid = size(txtDesalCandid,1); % number of desal plants
nameDesalCandid = txtDesalCandid(:,1); % desal plant name
IDDesalCandid = numDesalCandid(:,1); % desal plant ID [-]
waterCapacityDesalCandid = numDesalCandid(:,8); % desal plant water capacity [m^3/day]
powerConsumptionDesalCandid = numDesalCandid(:,9); % desal plant power consumption [kWh/m^3]
waterCapexDesalCandid = numDesalCandid(:,10); % desal plant water capacity expansion cost [USD/(m^3/day)/year]
waterOpexDesalCandid = numDesalCandid(:,11); % desal plant water operation cost [USD/m^3]
waterCO2DesalCandid = numDesalCandid(:,12); % desal plant water CO2 emission [kg/m^3]
powerCapacityDesalCandid = numDesalCandid(:,14); % desal plant power capacity [MW]
powerCapexDesalCandid = numDesalCandid(:,15); % desal plant power capacity expansion cost [USD/MW/year]
powerOpexDesalCandid = numDesalCandid(:,16); % desal plant power operation cost [USD/kWh]
powerCO2DesalCandid = numDesalCandid(:,17); % desal plant power CO2 emission [kg/kWh]
capexDesalCandid = numDesalCandid(:,20); % desal plant annum capital cost [USD/year]

for n = 1:nDesalCandid
    i = index(listID,IDDesalCandid(n));
    j = i;
    
    % cx, cy, cz
    [cx,cy,cz] = defineObjFun(i,j,flow,v,w,KPI);
    cy{index(KPI,'CAPEX')}(index(flow,'feed water'),1) = waterCapexDesalCandid(n); % CAPEX on feedwater outflow [USD/(m^3/day)/year]
    cy{index(KPI,'CAPEX')}(index(flow,'power resource'),1) = powerCapexDesalCandid(n)/10^3/24; % CAPEX on power resource outflow [USD/(kWh/day)/year]
    cz{index(KPI,'CAPEX')} = capexDesalCandid(n); % CAPEX on feedwater outflow [USD/year]
    cx{index(KPI,'OPEX')}(index(flow,'feed water'),1) = waterOpexDesalCandid(n)*365; % OPEX on feedwater outflow [USD/(m^3/day)/year]
    cx{index(KPI,'OPEX')}(index(flow,'power resource'),1) = powerOpexDesalCandid(n)*365; % OPEX on power resource outflow [USD/(kWh/day)/year]
    cx{index(KPI,'CO2')}(index(flow,'feed water'),1) = waterCO2DesalCandid(n)*365; % CO2 emission on feedwater outflow [kg/(m^3/day)/year]
    cx{index(KPI,'CO2')}(index(flow,'power resource'),1) = powerCO2DesalCandid(n)*365; % CO2 emission on power resource outflow [kg/(kWh/day)/year]
    
    % Ao, Ai
    % Power Consumption [kWh/day]
    Ao = sparse(eye(v));
    Ao(index(flow,'electricity'),index(flow,'feed water')) = powerConsumptionDesalCandid(n); % desal plant power consumption [kWh/m^3]
    Ai = sparse(eye(v));
    
    % B
    % Water Production
    % Electricity Production
    B = sparse(v,v);
    B(index(flow,'potable water'),index(flow,'feed water')) = 1; % desalination: feed water -> potable water
    B(index(flow,'electricity'),index(flow,'power resource')) = 1; % electricity production: power resource -> electricity
    
    % Co, Ci
    % No Concurrency
    Co = [];
    Ci = [];
    
    % lo, li
    lo = sparse(v,1);
    li = sparse(v,1);
    
    % uo, ui
    % Water Current Capacity
    % Power Current Capacity
    uo = sparse(v,1);
    uo(index(flow,'feed water')) = waterCapacityDesalCandid(n); % [m^3/day]
    uo(index(flow,'power resource')) = powerCapacityDesalCandid(n)*10^3*24; % [kWh/day]
    ui = sparse(v,1);
    ui(index(flow,'potable water')) = Inf;
    ui(index(flow,'electricity')) = Inf;
    
    ee = size(setEdge,1);
    setEdge{ee+1,1} = IDDesalCandid(n); % ID
    setEdge{ee+1,2} = strcat(nameDesalCandid(n),' Resource Processing'); % name
    setEdge{ee+1,3} = {'desal resource processing' 'existing'}; % type
    setEdge{ee+1,4} = [i j]; % origin & destination
    setEdge{ee+1,5} = cx;
    setEdge{ee+1,6} = cy;
    setEdge{ee+1,7} = cz;
    setEdge{ee+1,8} = Ao;
    setEdge{ee+1,9} = Ai;
    setEdge{ee+1,10} = B;
    setEdge{ee+1,11} = Co;
    setEdge{ee+1,12} = Ci;
    setEdge{ee+1,13} = lo;
    setEdge{ee+1,14} = li;
    setEdge{ee+1,15} = uo;
    setEdge{ee+1,16} = ui;
end

end
