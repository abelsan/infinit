%% Setting Up Existing Edges
% Inputs
%   Set of Nodes: setNode
%   Set of Edges: setEdge
%   Raw Data
%   Flow Vector: flow
%   Size of Flow Vector: v
%   Binary Vector: binary
%   Size of Binary Vector: w
%   Key Performance Indicators: KPI
% Outputs
%   Set of Edges: setEdge

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [setEdge] = setupExistingEdges(setNode,setEdge,numPipeline,txtPipeline,numPowerline,txtPowerline,flow,v,binary,w,KPI)

%% Settings
listID = cell2mat(setNode(:,1));
g0 = 9.80665; % gravitational constant [m/s^2]

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

%% Pipeline
% Text
%   A1: Origin
%   B2: Destination
% Number
%   C1: ID [-]
% ----------
%   D2: Origin_ID [-]
%   E3: Destination_ID [-]
% ----------
%   F4: Highest Elevation [m]
% ----------
%   G5: Distance [km]
%   H6: Diameter [mm]
% ----------
%   I7: Water Capacity [m^3/day]
% ----------
%   J8: Friction Head Loss [m^2/s^2]
%   K9: Water Loss [-]
%  L10: Electricity Loss [-]
% ----------
%  M11: Water Operation Cost [USD/year]
%  N12: Power Operation Cost [USD/year]
nPipeline = size(numPipeline,1); % number of pipelines
originPipeline = txtPipeline(:,1); % origin of pipeline
destinationPipeline = txtPipeline(:,2); % destination of pipeline
IDPipeline = numPipeline(:,1); % ID of pipeline
originIDPipeline = numPipeline(:,2); % origin ID of pipeline
destinationIDPipeline = numPipeline(:,3); % destination ID of pipeline
highestPipeline = numPipeline(:,4); % highest elevation of pipeline [m]
waterCapacityPipeline = numPipeline(:,7); % water capacity [m^3/day]
frictionHeadLossPipeline = numPipeline(:,8); % friction head loss [m^2/s^2]
waterLossPipeline = numPipeline(:,9); % water loss [-]
electricityLossPipeline = numPipeline(:,10); % electricity loss [-]
waterOpexPipeline = numPipeline(:,11); % water operation cost [USD/year]
powerOpexPipeline = numPipeline(:,12); % power operation cost [USD/year]

for e = 1:nPipeline
    i = index(listID,originIDPipeline(e));
    j = index(listID,destinationIDPipeline(e));
    elevation_ij = setNode{j,5}(3)-setNode{i,5}(3); % elevation difference from i to j [m]
    elevation_ji = -elevation_ij; % elevation difference from j to i [m]
    pump_ij = max(elevation_ij*g0+frictionHeadLossPipeline(e),0)/3600; % pumping energy from i to j [kWh/m^3]
    pump_ji = max(elevation_ji*g0+frictionHeadLossPipeline(e),0)/3600; % pumping energy from j to i [kWh/m^3]
    
    % i to j
    % cx, cy, cz
    [cx,cy,cz] = defineObjFun(i,j,flow,v,w,KPI);
    cz{index(KPI,'OPEX')}(index(binary,'water'),1) = waterOpexPipeline(e); % OPEX on potable water outflow [USD/year]
    cz{index(KPI,'OPEX')}(index(binary,'power'),1) = powerOpexPipeline(e); % OPEX on electricity outflow [USD/year]
%     cz{index(KPI,'OPEX')}(index(flow,'potable water'),1) = waterOpexPipeline(e); % OPEX on potable water outflow [USD/year]
%     cz{index(KPI,'OPEX')}(index(flow,'electricity'),1) = powerOpexPipeline(e); % OPEX on electricity outflow [USD/year]
    
    % Ao, Ai
    % Power Consumption [kWh/day]
    Ao = sparse(eye(v));
    Ao(index(flow,'electricity'),index(flow,'feed water')) = pump_ij; % feed water -> electricity [kWh/m^3]
    Ao(index(flow,'electricity'),index(flow,'potable water')) = pump_ij; % potable water -> electricity [kWh/m^3]
    Ao(index(flow,'electricity'),index(flow,'non-potable water')) = pump_ij; % non-potable water -> electricity [kWh/m^3]
    Ao(index(flow,'electricity'),index(flow,'waste water')) = pump_ij; % waste water -> electricity [kWh/m^3]
    Ai = sparse(eye(v));
    
    % B
    % Water Loss during Transmission
    % Electricity Loss during Transmission
    B = sparse(v,v);
    B(index(flow,'feed water'),index(flow,'feed water')) = 1-waterLossPipeline(e); % water loss: feed water -> feed water
    B(index(flow,'potable water'),index(flow,'potable water')) = 1-waterLossPipeline(e); % water loss: potable water -> potable water
    B(index(flow,'non-potable water'),index(flow,'non-potable water')) = 1-waterLossPipeline(e); % water loss: non-potable water -> non-potable water
    B(index(flow,'waste water'),index(flow,'waste water')) = 1-waterLossPipeline(e); % water loss: waste water -> waste water
    B(index(flow,'electricity'),index(flow,'electricity')) = 1-electricityLossPipeline(e); % electricity loss: electricity -> electricity
    
    % Co, Ci
    % No Concurrency
    Co = [];
    Ci = [];
    
    % lo, li
    lo = sparse(v,1);
    li = sparse(v,1);
    
    % uo, ui
    % Water Current Capacity
    % Wastewater Current Capacity
    uo = sparse(v,1);
    uo(index(flow,'potable water')) = waterCapacityPipeline(e); % [m^3/day]
    uo(index(flow,'electricity')) = Inf;
    ui = sparse(v,1);
    ui(index(flow,'potable water')) = Inf;
    ui(index(flow,'electricity')) = Inf;
    
    ee = size(setEdge,1);
    setEdge{ee+1,1} = IDPipeline(e); % ID
    setEdge{ee+1,2} = sprintf('%s - %s',originPipeline{e},destinationPipeline{e}); % name
    setEdge{ee+1,3} = {'pipeline' 'existing'}; % type
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
    
    % j to i
    % cx, cy, cz
    [cx,cy,cz] = defineObjFun(j,i,flow,v,w,KPI);
    cz{index(KPI,'OPEX')}(index(binary,'water'),1) = waterOpexPipeline(e); % OPEX on potable water outflow [USD/year]
    cz{index(KPI,'OPEX')}(index(binary,'power'),1) = powerOpexPipeline(e); % OPEX on electricity outflow [USD/year]
%     cz{index(KPI,'OPEX')}(index(flow,'potable water'),1) = waterOpexPipeline(e); % OPEX on potable water outflow [USD/year]
%     cz{index(KPI,'OPEX')}(index(flow,'electricity'),1) = powerOpexPipeline(e); % OPEX on electricity outflow [USD/year]
    
    % Ao, Ai
    % Power Consumption [kWh/day]
    Ao = sparse(eye(v));
    Ao(index(flow,'electricity'),index(flow,'feed water')) = pump_ji; % feed water -> electricity [kWh/m^3]
    Ao(index(flow,'electricity'),index(flow,'potable water')) = pump_ji; % potable water -> electricity [kWh/m^3]
    Ao(index(flow,'electricity'),index(flow,'non-potable water')) = pump_ji; % non-potable water -> electricity [kWh/m^3]
    Ao(index(flow,'electricity'),index(flow,'waste water')) = pump_ji; % waste water -> electricity [kWh/m^3]
    Ai = sparse(eye(v));
    
    % B
    % Water Loss during Transmission
    % Electricity Loss during Transmission
    B = sparse(v,v);
    B(index(flow,'feed water'),index(flow,'feed water')) = 1-waterLossPipeline(e); % water loss: feed water -> feed water
    B(index(flow,'potable water'),index(flow,'potable water')) = 1-waterLossPipeline(e); % water loss: potable water -> potable water
    B(index(flow,'non-potable water'),index(flow,'non-potable water')) = 1-waterLossPipeline(e); % water loss: non-potable water -> non-potable water
    B(index(flow,'waste water'),index(flow,'waste water')) = 1-waterLossPipeline(e); % water loss: waste water -> waste water
    B(index(flow,'electricity'),index(flow,'electricity')) = 1-electricityLossPipeline(e); % electricity loss: electricity -> electricity
    
    % Co, Ci
    % No Concurrency
    Co = [];
    Ci = [];
    
    % lo, li
    lo = sparse(v,1);
    li = sparse(v,1);
    
    % uo, ui
    % Water Current Capacity
    % Wastewater Current Capacity
    uo = sparse(v,1);
    uo(index(flow,'potable water')) = waterCapacityPipeline(e); % [m^3/day]
    uo(index(flow,'electricity')) = Inf;
    ui = sparse(v,1);
    ui(index(flow,'potable water')) = Inf;
    ui(index(flow,'electricity')) = Inf;
    
    ee = size(setEdge,1);
    setEdge{ee+1,1} = -IDPipeline(e); % ID
    setEdge{ee+1,2} = sprintf('%s - %s',destinationPipeline{e},originPipeline{e}); % name
    setEdge{ee+1,3} = {'pipeline' 'existing'}; % type
    setEdge{ee+1,4} = [j i]; % origin & destination
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

%% Powerline
% Text
%   A1: Origin
%   B2: Destination
% Number
%   C1: ID [-]
% ----------
%   D2: Origin_ID [-]
%   E3: Destination_ID [-]
% ----------
%   F4: Distance [km]
% ----------
%   G5: Electricity Loss [-]
% ----------
%   H6: Power Operation Cost [USD/year]
nPowerline = size(numPowerline,1); % number of powerlines
originPowerline = txtPowerline(:,1); % origin of powerline
destinationPowerline = txtPowerline(:,2); % destination of powerline
IDPowerline = numPowerline(:,1); % ID of powerline
originIDPowerline = numPowerline(:,2); % origin ID of powerline
destinationIDPowerline = numPowerline(:,3); % destination ID of powerline
electricityLossPowerline = numPowerline(:,5); % electricity loss [-]
powerOpexPowerline = numPowerline(:,6); % power operation cost [USD/year]

for e = 1:nPowerline
    i = index(listID,originIDPowerline(e));
    j = index(listID,destinationIDPowerline(e));

    % i to j
    % cx, cy, cz
    [cx,cy,cz] = defineObjFun(i,j,flow,v,w,KPI);
    cz{index(KPI,'OPEX')}(index(binary,'power'),1) = powerOpexPowerline(e); % OPEX on electricity outflow [USD/year]
%     cz{index(KPI,'OPEX')}(index(flow,'electricity'),1) = powerOpexPowerline(e); % OPEX on electricity outflow [USD/year]
    
    % Ao, Ai
    Ao = sparse(eye(v));
    Ai = sparse(eye(v));
    
    % B
    % Electricity Loss during Transmission
    B = sparse(v,v);
    B(index(flow,'electricity'),index(flow,'electricity')) = 1-electricityLossPowerline(e); % electricity loss: electricity -> electricity
    
    % Co, Ci
    % No Concurrency
    Co = [];
    Ci = [];
    
    % lo, li
    lo = sparse(v,1);
    li = sparse(v,1);
    
    % uo, ui
    % Wastewater Current Capacity
    uo = sparse(v,1);
    uo(index(flow,'electricity')) = Inf;
    ui = sparse(v,1);
    ui(index(flow,'electricity')) = Inf;
    
    ee = size(setEdge,1);
    setEdge{ee+1,1} = IDPowerline(e); % ID
    setEdge{ee+1,2} = sprintf('%s - %s',originPowerline{e},destinationPowerline{e}); % name
    setEdge{ee+1,3} = {'powerline' 'existing'}; % type
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
    
    % j to i
    % cx, cy, cz
    [cx,cy,cz] = defineObjFun(j,i,flow,v,w,KPI);
    cz{index(KPI,'OPEX')}(index(binary,'power'),1) = powerOpexPowerline(e); % OPEX on electricity outflow [USD/year]        
%     cz{index(KPI,'OPEX')}(index(flow,'electricity'),1) = powerOpexPowerline(e); % OPEX on electricity outflow [USD/year]
    
    % Ao, Ai
    Ao = sparse(eye(v));
    Ai = sparse(eye(v));
    
    % B
    % Electricity Loss during Transmission
    B = sparse(v,v);
    B(index(flow,'electricity'),index(flow,'electricity')) = 1-electricityLossPowerline(e); % electricity loss: electricity -> electricity
    
    % Co, Ci
    % No Concurrency
    Co = [];
    Ci = [];
    
    % lo, li
    lo = sparse(v,1);
    li = sparse(v,1);
    
    % uo, ui
    % Wastewater Current Capacity
    uo = sparse(v,1);
    uo(index(flow,'electricity')) = Inf;
    ui = sparse(v,1);
    ui(index(flow,'electricity')) = Inf;
    
    ee = size(setEdge,1);
    setEdge{ee+1,1} = -IDPowerline(e); % ID
    setEdge{ee+1,2} = sprintf('%s - %s',destinationPowerline{e},originPowerline{e}); % name
    setEdge{ee+1,3} = {'powerline' 'existing'}; % type
    setEdge{ee+1,4} = [j i]; % origin & destination
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
