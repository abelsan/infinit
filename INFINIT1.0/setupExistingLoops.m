%% Setting Up Existing Loops
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

function [setEdge] = setupExistingLoops(setNode,setEdge,numCity,txtCity,numDesal,txtDesal,numPower,txtPower,flow,v,w,KPI)

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

%% City
% Ground Water Processing: feed water -> potable water
% Wastewater Treatment: waste water -> non-potable water
% Potable Water for Non-Drinking Use: potable water -> non-potable water
% Text
%   A1: City
%   Administration
%      B2: Region
%      C3: Abbr.
% Number
%   D1: ID [-]
% ----------
%   E2: Latitude [deg N]
%   F3: Longitude [deg E]
%   G4: Elevation [m]
% ----------
%   H5: Population 2010 [ppl]
%   I6: Estimated Population [ppl]
% ----------
%   J7: Ave. Daily Water [liters/day/capita]
%   Water Demand [m^3/day]
%      K8: Potable
%      L9: Non-Potable
% ----------
%  M10: Groundwater Capacity [m^3/day]
%  N11: Power Consumption [kWh/m^3]
%  O12: Capacity Expansion Cost [USD/m^3]
%  P13: Operation Cost [USD/m^3]
%  Q14: CO2 Emission [kg/m^3]
% ----------
%  R15: Wastewater Generation [m^3/day]
%  S16: Wastewater Treatment? [binary]
%  T17: Recovery Rate [%]
%  U18: Wastewater Treatment Capacity [m^3/day]
%  V19: Power Consumption [kWh/m^3]
%  W20: Capacity Expansion Cost [USD/m^3]
%  X21: Operation Cost [USD/m^3]
%  Y22: CO2 Emission [kg/m^3]
% ----------
%  Z23: Ave. Daily Power [kWh/day/capita]
% AA24: Power Demand [kWh/day]
nCity = size(txtCity,1); % number of cities
nameCity = txtCity(:,1); % city name
IDCity = numCity(:,1); % ID of city [-]
groundCapacityCity = numCity(:,10); % groundwater capacity [m^3/day]
groundPowerConsumptionCity = numCity(:,11); % groundwater power consumption [kWh/m^3]
groundCapexCity = numCity(:,12); % groundwater capacity expansion cost [USD/(m^3/day)/year]
groundOpexCity = numCity(:,13); % groundwater operation cost [USD/m^3]
groundCO2City = numCity(:,14); % groundwater CO2 emission [kg/m^3]
wasteRecoveryRateCity = numCity(:,17); % wastewater recovery rate [%]
wasteCapacityCity = numCity(:,18); % wastewater treatment capacity [m^3/day]
wastePowerConsumptionCity = numCity(:,19); % wastewater power consumption [kWh/m^3]
wasteCapexCity = numCity(:,20); % wastewater capacity expansion cost [USD/(m^3/day)/year]
wasteOpexCity = numCity(:,21); % wastewater operation cost [USD/m^3]
wasteCO2City = numCity(:,22); % wastewater CO2 emission [kg/m^3]

for n = 1:nCity
    i = index(listID,IDCity(n));
    j = i;
    
    % cx, cy, cz
    [cx,cy,cz] = defineObjFun(i,j,flow,v,w,KPI);
    cy{index(KPI,'CAPEX')}(index(flow,'feed water'),1) = groundCapexCity(n); % CAPEX on feedwater outflow [USD/(m^3/day)/year]
    cy{index(KPI,'CAPEX')}(index(flow,'waste water'),1) = wasteCapexCity(n); % CAPEX on wastewater outflow [USD/(m^3/day)/year]
    cx{index(KPI,'OPEX')}(index(flow,'feed water'),1) = groundOpexCity(n)*365; % OPEX on feedwater outflow [USD/(m^3/day)/year]
    cx{index(KPI,'OPEX')}(index(flow,'waste water'),1) = wasteOpexCity(n)*365; % OPEX on wastewater outflow [USD/(m^3/day)/year]
    cx{index(KPI,'CO2')}(index(flow,'feed water'),1) = groundCO2City(n)*365; % OPEX on feedwater outflow [USD/(m^3/day)/year]
    cx{index(KPI,'CO2')}(index(flow,'waste water'),1) = wasteCO2City(n)*365; % OPEX on wastewater outflow [USD/(m^3/day)/year]
    
    % Ao, Ai
    % Power Consumption [kWh/day]
    Ao = sparse(eye(v));
    Ao(index(flow,'electricity'),index(flow,'feed water')) = groundPowerConsumptionCity(n); % groundwater power consumption [kWh/m^3]
    Ao(index(flow,'electricity'),index(flow,'waste water')) = wastePowerConsumptionCity(n); % wastewater power consumption [kWh/m^3]
    Ai = sparse(eye(v));
    
    % B
    % Groundwater Processing
    % Potable for Non-Potable Use
    % Wastewater Treatment
    B = sparse(v,v);
    B(index(flow,'potable water'),index(flow,'feed water')) = 1; % groundwater processing: feed water -> potable water
    B(index(flow,'non-potable water'),index(flow,'potable water')) = 1; % allowing potable for non-potable use: potable water -> non-potable water
    B(index(flow,'non-potable water'),index(flow,'waste water')) = wasteRecoveryRateCity(n); % wastewater recovery rate: waste water -> non-potable water
    
    % Co, Ci
    % No Concurrency
    Co = [];
    Ci = [];
    
    % lo, li
    lo = sparse(v,1);
    li = sparse(v,1);
    
    % uo, ui
    % Groundwater Current Capacity
    % Wastewater Current Capacity
    uo = sparse(v,1);
    uo(index(flow,'feed water')) = groundCapacityCity(n); % [m^3/day]
    uo(index(flow,'potable water')) = Inf;
    uo(index(flow,'waste water')) = wasteCapacityCity(n); % [m^3/day]
    ui = sparse(v,1);
    ui(index(flow,'potable water')) = Inf;
    ui(index(flow,'non-potable water')) = Inf;
    
    ee = size(setEdge,1);
    setEdge{ee+1,1} = IDCity(n); % ID
    setEdge{ee+1,2} = strcat(nameCity(n),' Resource Processing'); % name
    setEdge{ee+1,3} = {'city resource processing' 'existing'}; % type
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
nDesal = size(txtDesal,1); % number of desal plants
nameDesal = txtDesal(:,1); % desal plant name
IDDesal = numDesal(:,1); % desal plant ID [-]
waterCapacityDesal = numDesal(:,8); % desal plant water capacity [m^3/day]
powerConsumptionDesal = numDesal(:,9); % desal plant power consumption [kWh/m^3]
waterCapexDesal = numDesal(:,10); % desal plant water capacity expansion cost [USD/(m^3/day)/year]
waterOpexDesal = numDesal(:,11); % desal plant water operation cost [USD/m^3]
waterCO2Desal = numDesal(:,12); % desal plant water CO2 emission [kg/m^3]
powerCapacityDesal = numDesal(:,14); % desal plant power capacity [MW]
powerCapexDesal = numDesal(:,15); % desal plant power capacity expansion cost [USD/MW/year]
powerOpexDesal = numDesal(:,16); % desal plant power operation cost [USD/kWh]
powerCO2Desal = numDesal(:,17); % desal plant power CO2 emission [kg/kWh]

for n = 1:nDesal
    i = index(listID,IDDesal(n));
    j = i;
    
    % cx, cy, cz
    [cx,cy,cz] = defineObjFun(i,j,flow,v,w,KPI);
    cy{index(KPI,'CAPEX')}(index(flow,'feed water'),1) = waterCapexDesal(n); % CAPEX on feedwater outflow [USD/(m^3/day)/year]
    cy{index(KPI,'CAPEX')}(index(flow,'power resource'),1) = powerCapexDesal(n)/10^3/24; % CAPEX on power resource outflow [USD/(kWh/day)/year]
    cx{index(KPI,'OPEX')}(index(flow,'feed water'),1) = waterOpexDesal(n)*365; % OPEX on feedwater outflow [USD/(m^3/day)/year]
    cx{index(KPI,'OPEX')}(index(flow,'power resource'),1) = powerOpexDesal(n)*365; % OPEX on power resource outflow [USD/(kWh/day)/year]
    cx{index(KPI,'CO2')}(index(flow,'feed water'),1) = waterCO2Desal(n)*365; % CO2 emission on feedwater outflow [kg/(m^3/day)/year]
    cx{index(KPI,'CO2')}(index(flow,'power resource'),1) = powerCO2Desal(n)*365; % CO2 emission on power resource outflow [kg/(kWh/day)/year]
    
    % Ao, Ai
    % Power Consumption [kWh/day]
    Ao = sparse(eye(v));
    Ao(index(flow,'electricity'),index(flow,'feed water')) = powerConsumptionDesal(n); % desal plant power consumption [kWh/m^3]
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
    uo(index(flow,'feed water')) = waterCapacityDesal(n); % [m^3/day]
    uo(index(flow,'power resource')) = powerCapacityDesal(n)*10^3*24; % [kWh/day]
    ui = sparse(v,1);
    ui(index(flow,'potable water')) = Inf;
    ui(index(flow,'electricity')) = Inf;
    
    ee = size(setEdge,1);
    setEdge{ee+1,1} = IDDesal(n); % ID
    setEdge{ee+1,2} = strcat(nameDesal(n),' Resource Processing'); % name
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

%% Power Plant
% Electricity Production: power resource -> electricity
% Text
%   A1: Power Plant
%   Administration
%      B2: Region
%      C3: Abbr.
%   D4: Fuel
% Number
%   E1: ID [-]
% ----------
%   F2: Latitude [deg N]
%   G3: Longitude [deg E]
%   H4: Elevation [m]
% ----------
%   I5: Power Capacity [MW]
%   J6: Capacity Expansion Cost [USD/kWh]
%   K7: Operation Cost [USD/kWh]
%   L8: CO2 Emission [kg/kWh]
nPower = size(numPower,1); % number of power plants
namePower = txtPower(:,1); % power plant name
IDPower = numPower(:,1); % ID of power plant [-]
powerCapacityPower = numPower(:,5); % power plant power capacity [MW]
powerCapexPower = numPower(:,6); % power plant capacity expansion cost [USD/MW/year]
powerOpexPower = numPower(:,7); % power plant operation cost [USD/kWh]
powerCO2Power = numPower(:,8); % power plant CO2 emission [kg/kWh]

for n = 1:nPower
    i = index(listID,IDPower(n));
    j = i;
    
    % cx, cy, cz
    [cx,cy,cz] = defineObjFun(i,j,flow,v,w,KPI);
    cy{index(KPI,'CAPEX')}(index(flow,'power resource'),1) = powerCapexPower(n)/10^3/24; % CAPEX on power resource outflow [USD/(kWh/day)/year]
    cx{index(KPI,'OPEX')}(index(flow,'power resource'),1) = powerOpexPower(n)*365; % OPEX on power resource outflow [USD/(kWh/day)/year]
    cx{index(KPI,'CO2')}(index(flow,'power resource'),1) = powerCO2Power(n)*365; % CO2 emission on power resource outflow [kg/(kWh/day)/year]
    
    % Ao, Ai
    Ao = sparse(eye(v));
    Ai = sparse(eye(v));
    
    % B
    % Electricity Production
    B = sparse(v,v);
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
    uo(index(flow,'power resource')) = powerCapacityPower(n)*10^3*24; % [kWh/day]
    ui = sparse(v,1);
    ui(index(flow,'electricity')) = Inf;
    
    % setEdge
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
    % 11: constraint matrix for outflow: Co
    % 12: constraint matrix for inflow: Ci
    % 13: current capacity for outflow: uo
    % 14: current capacity for inflow: ui
    ee = size(setEdge,1);
    setEdge{ee+1,1} = IDPower(n); % ID
    setEdge{ee+1,2} = strcat(namePower(n),' Resource Processing'); % name
    setEdge{ee+1,3} = {'power resource processing' 'existing'}; % type
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
