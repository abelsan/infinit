%% Setting Up Candidate Nodes
% Inputs
%   Set of Nodes: setNode
%   Raw Data
%   Flow Vector: flow
%   Size of Flow Vector: v
% Outputs
%   Set of Nodes: setNode

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [setNode] = setupCandidateNodes(setNode,numDesalCandid,txtDesalCandid,flow,v)

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

%% City Candidate
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
% nCityCandid = size(txtCityCandid,1); % number of cities
% nameCityCandid = txtCityCandid(:,1); % city name
% regionCityCandid = txtCityCandid(:,2); % city region
% IDCityCandid = numCityCandid(:,1); % ID of city [-]
% latCityCandid = numCityCandid(:,2); % latitude of city [deg N]
% lonCityCandid = numCityCandid(:,3); % longitude of city [deg E]
% elevCityCandid = numCityCandid(:,4); % elevation of city [m]
% populationCityCandid = numCityCandid(:,6); % population of city [ppl]
% potableDemandCityCandid = numCityCandid(:,8); % potable water demand [m^3/day]
% nonpotableDemandCityCandid = numCityCandid(:,9); % non-potable water demand [m^3/day]
% groundCapacityCityCandid = numCityCandid(:,10); % groundwater capacity [m^3/day]
% wasteSupplyCityCandid = numCityCandid(:,15); % wastewater supply [m^3/day]
% wasteCapacityCityCandid = numCityCandid(:,18); % wastewater treatment capacity [m^3/day]
% powerDemandCityCandid = numCityCandid(:,24); % power demand [kWh/day]
% 
% for n = 1:nCityCandid
%     ii = size(setNode,1);
%     setNode{ii+1,1} = IDCityCandid(n); % ID
%     setNode{ii+1,2} = nameCityCandid(n); % name
%     setNode{ii+1,3} = regionCityCandid(n); % region
%     setNode{ii+1,4} = {'city' 'candid'}; % type
%     setNode{ii+1,5} = [latCityCandid(n) lonCityCandid(n) elevCityCandid(n)]; % coordinates
%     setNode{ii+1,6} = zeros(v,1); % supply/demand
%     setNode{ii+1,6}(index(flow,'feed water'),1) = qinf; % supply
%     setNode{ii+1,6}(index(flow,'potable water'),1) = -potableDemandCityCandid(n); % demand
%     setNode{ii+1,6}(index(flow,'non-potable water'),1) = -nonpotableDemandCityCandid(n); % demand
%     setNode{ii+1,6}(index(flow,'waste water'),1) = wasteSupplyCityCandid(n); % supply
%     setNode{ii+1,6}(index(flow,'electricity'),1) = -powerDemandCityCandid(n); % demand
%     setNode{ii+1,7} = [populationCityCandid(n) groundCapacityCityCandid(n) wasteCapacityCityCandid(n)]; % other important properties
% end

%% Desal Candidate
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
nDesalCandid = size(txtDesalCandid,1); % number of desal plants
nameDesalCandid = txtDesalCandid(:,1); % desal plant name
regionDesalCandid = txtDesalCandid(:,2); % desal plant region
IDDesalCandid = numDesalCandid(:,1); % ID of desal plant [-]
latDesalCandid = numDesalCandid(:,2); % latitude of desal plant [deg N]
lonDesalCandid = numDesalCandid(:,3); % longitude of desal plant [deg E]
elevDesalCandid = numDesalCandid(:,4); % elevation of desal plant [m]
waterCapacityDesalCandid = numDesalCandid(:,8); % desal plant water capacity [m^3/day]
powerCapacityDesalCandid = numDesalCandid(:,14); % desal plant power capacity [MW]

for n = 1:nDesalCandid
    ii = size(setNode,1);
    setNode{ii+1,1} = IDDesalCandid(n); % ID
    setNode{ii+1,2} = nameDesalCandid(n); % name
    setNode{ii+1,3} = regionDesalCandid(n); % region
    setNode{ii+1,4} = {'desal' 'candid'}; % type
    setNode{ii+1,5} = [latDesalCandid(n) lonDesalCandid(n) elevDesalCandid(n)]; % coordinates
    setNode{ii+1,6} = zeros(v,1); % supply/demand
    setNode{ii+1,6}(index(flow,'feed water'),1) = qinf; % supply
    setNode{ii+1,6}(index(flow,'power resource'),1) = qinf; % supply
    setNode{ii+1,7} = [waterCapacityDesalCandid(n) powerCapacityDesalCandid(n)]; % other important properties
end

%% Power Candidate
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
% nPowerCandid = size(numPowerCandid,1); % number of power plants
% namePowerCandid = txtPowerCandid(:,1); % power plant name
% regionPowerCandid = txtPowerCandid(:,2); % power plant region
% IDPowerCandid = numPowerCandid(:,1); % ID of power plant [-]
% latPowerCandid = numPowerCandid(:,2); % latitude of power plant [deg N]
% lonPowerCandid = numPowerCandid(:,3); % longitude of power plant [deg E]
% elevPowerCandid = numPowerCandid(:,4); % elevation of power plant [m]
% powerCapacityPowerCandid = numPowerCandid(:,5); % power plant power capacity [MW]
% 
% for n = 1:nPowerCandid
%     ii = size(setNode,1);
%     setNode{ii+1,1} = IDPowerCandid(n); % ID
%     setNode{ii+1,2} = namePowerCandid(n); % name
%     setNode{ii+1,3} = regionPowerCandid(n); % region
%     setNode{ii+1,4} = {'power' 'candid'}; % type
%     setNode{ii+1,5} = [latPowerCandid(n) lonPowerCandid(n) elevPowerCandid(n)]; % coordinates
%     setNode{ii+1,6} = zeros(v,1); % supply/demand
%     setNode{ii+1,6}(index(flow,'feed water'),1) = qinf; % supply
%     setNode{ii+1,6}(index(flow,'power resource'),1) = qinf; % supply
%     setNode{ii+1,7} = [powerCapacityPowerCandid(n)]; % other important properties
% end

end
