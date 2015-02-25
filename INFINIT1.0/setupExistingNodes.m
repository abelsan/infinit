%% Setting Up Existing Nodes
% Inputs
%   Set of Nodes: setNode
%   Raw Data
%   Flow Vector: flow
%   Size of Flow Vector: v
% Outputs
%   Set of Nodes: setNode

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [setNode] = setupExistingNodes(setNode,numCity,txtCity,numDesal,txtDesal,numPower,txtPower,flow,v)

%% Settings
qinf = 10^12; % quasi-infinity

%% Defining Serial Nodes
%  1: node ID
%  2: node name
%  3: node region
%  4: node type
%  5: coordinates
%  6: supply/demand
%  7: other important properties

%% City
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
regionCity = txtCity(:,2); % city region
IDCity = numCity(:,1); % ID of city [-]
latCity = numCity(:,2); % latitude of city [deg N]
lonCity = numCity(:,3); % longitude of city [deg E]
elevCity = numCity(:,4); % elevation of city [m]
populationCity = numCity(:,6); % population of city [ppl]
potableDemandCity = numCity(:,8); % potable water demand [m^3/day]
nonpotableDemandCity = numCity(:,9); % non-potable water demand [m^3/day]
groundCapacityCity = numCity(:,10); % groundwater capacity [m^3/day]
wasteSupplyCity = numCity(:,15); % wastewater supply [m^3/day]
wasteCapacityCity = numCity(:,18); % wastewater treatment capacity [m^3/day]
powerDemandCity = numCity(:,24); % power demand [kWh/day]

for n = 1:nCity
    ii = size(setNode,1);
    setNode{ii+1,1} = IDCity(n); % ID
    setNode{ii+1,2} = nameCity(n); % name
    setNode{ii+1,3} = regionCity(n); % region
    setNode{ii+1,4} = {'city' 'existing'}; % type
    setNode{ii+1,5} = [latCity(n) lonCity(n) elevCity(n)]; % coordinates
    setNode{ii+1,6} = zeros(v,1); % supply/demand
    setNode{ii+1,6}(index(flow,'feed water'),1) = qinf; % supply
    setNode{ii+1,6}(index(flow,'potable water'),1) = -potableDemandCity(n); % demand
    setNode{ii+1,6}(index(flow,'non-potable water'),1) = -nonpotableDemandCity(n); % demand
    setNode{ii+1,6}(index(flow,'waste water'),1) = wasteSupplyCity(n); % supply
    setNode{ii+1,6}(index(flow,'electricity'),1) = -powerDemandCity(n); % demand
    setNode{ii+1,7} = [populationCity(n) groundCapacityCity(n) wasteCapacityCity(n)]; % other important properties
end

%% Desal Plant
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
regionDesal = txtDesal(:,2); % desal plant region
IDDesal = numDesal(:,1); % ID of desal plant [-]
latDesal = numDesal(:,2); % latitude of desal plant [deg N]
lonDesal = numDesal(:,3); % longitude of desal plant [deg E]
elevDesal = numDesal(:,4); % elevation of desal plant [m]
waterCapacityDesal = numDesal(:,8); % desal plant water capacity [m^3/day]
powerCapacityDesal = numDesal(:,14); % desal plant power capacity [MW]

for n = 1:nDesal
    ii = size(setNode,1);
    setNode{ii+1,1} = IDDesal(n); % ID
    setNode{ii+1,2} = nameDesal(n); % name
    setNode{ii+1,3} = regionDesal(n); % region
    setNode{ii+1,4} = {'desal' 'existing'}; % type
    setNode{ii+1,5} = [latDesal(n) lonDesal(n) elevDesal(n)]; % coordinates
    setNode{ii+1,6} = zeros(v,1); % supply/demand
    setNode{ii+1,6}(index(flow,'feed water'),1) = qinf; % supply
    setNode{ii+1,6}(index(flow,'power resource'),1) = qinf; % supply
    setNode{ii+1,7} = [waterCapacityDesal(n) powerCapacityDesal(n)]; % other important properties
end

%% Power Plant
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
regionPower = txtPower(:,2); % power plant region
IDPower = numPower(:,1); % ID of power plant [-]
latPower = numPower(:,2); % latitude of power plant [deg N]
lonPower = numPower(:,3); % longitude of power plant [deg E]
elevPower = numPower(:,4); % elevation of power plant [m]
powerCapacityPower = numPower(:,5); % power plant power capacity [MW]

for n = 1:nPower
    ii = size(setNode,1);
    setNode{ii+1,1} = IDPower(n); % ID
    setNode{ii+1,2} = namePower(n); % name
    setNode{ii+1,3} = regionPower(n); % region
    setNode{ii+1,4} = {'power' 'existing'}; % type
    setNode{ii+1,5} = [latPower(n) lonPower(n) elevPower(n)]; % coordinates
    setNode{ii+1,6} = zeros(v,1); % supply/demand
    setNode{ii+1,6}(index(flow,'feed water'),1) = qinf; % supply
    setNode{ii+1,6}(index(flow,'power resource'),1) = qinf; % supply
    setNode{ii+1,7} = [powerCapacityPower(n)]; % other important properties
end

end
