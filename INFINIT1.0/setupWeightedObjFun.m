tic;

%% Setup Objective Function
fprintf('Setting up Objective Function... ');

% Key performance indicators (KPI)
%   1: total capex [USD/year]
%   2: total opex [USD/year]
%   3: total CO2 emission [kg/day]
%   4: total potable water produced [m^3/day]
%   5: total electricity produced [kWh/day]
%   6: ...
KPI = {'CAPEX'
       'OPEX'
       'CO2'
       'potable water';
       'electricity'};

% Normalizer
normCost = 6.7173; % 2010-2030
normCO2 = 11.9896; % 2010-2030
% normCost = 6.8368; % 2010-2030 twice pipeline CAPEX
% normCO2 = 24.5628; % 2010-2030 twice pipeline CAPEX

% Objective Function Weight
W = zeros(size(KPI));
weightCost = 0.5;
weightCO2 = 1-weightCost;
W(index(KPI,'CAPEX')) = weightCost/normCost;
W(index(KPI,'OPEX')) = weightCost/normCost;
W(index(KPI,'CO2')) = weightCO2/normCO2;
W(index(KPI,'potable water')) = 0;
W(index(KPI,'electricity')) = 0;

[fall,f] = setupObjFun(v,w,W,E,cx,cy,cz);

t_setup = toc;
fprintf('\t %3.1f seconds and done! \n',t_setup);