%% Defining Objective Function
% Inputs
%   Origin and Destination IDs: i,j
%   Flow Vector: flow
%   Size of Flow Vector: v
%   Size of Binary Vector: w
%   Key Performance Indicators: KPI
% Outputs
%   Objective Function Coefficients: cxo,cxi,cyo,cyi,cz

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [cx,cy,cz] = defineObjFun(i,j,flow,v,w,KPI)

% Key performance indicators (KPI)
%   1: total CAPEX [USD/year]
%   2: total OPEX [USD/year]
%   3: total CO2 emission [kg/day]
%   4: total potable water produced [m^3/day]
%   5: total electricity produced [kWh/day]
%   6: ...
nKPI = size(KPI,1);
cx = cell(nKPI,1);
cy = cell(nKPI,1);
cz = cell(nKPI,1);
for n = 1:nKPI
    cx{n} = sparse(v,2); % outflow and inflow
    cy{n} = sparse(v,2); % outflow and inflow
    cz{n} = sparse(w,1);
end

if i == j
    cx{index(KPI,'potable water')}(index(flow,'potable water'),2) = 1; % potable water inflow
    cx{index(KPI,'electricity')}(index(flow,'electricity'),2) = 1; % electricity inflow
end

% rest defined elsewhere

end
