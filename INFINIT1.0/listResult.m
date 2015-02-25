%% Requesting Information about Nodes
% Inputs
%   Set of Nodes: setNode
%   Set of Edges: setEdge
%   Flow Vector: flow
%   Size of Flow Vector: v
%   Optimized Result: xyz
% Outputs
%   Results: cityResult,desalResult,powerResult

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [cityResult,desalResult,powerResult] = listResult(setNode,setEdge,flow,v,xyz)

nNode = size(setNode,1); % number of nodes

cityPotable = {{'City'},...
               {'Potable Water Demand [m^3/day]'},...
               {'Potable Water Supply by Ground Water [m^3/day]'},...
               {'Potable Water Supply by Others [m^3/day]'},...
               {'% supplied by Ground Water'},...
               {'% supplied by Others'},...
               {'Ground Water Capacity [m^3/day]'},...
               {'Capacity Expansion [m^3/day]'},...
               {'% utilized'}};
cityNonPotable = {{'City'},...
                  {'Non-Potable Water Demand [m^3/day]'},...
                  {'Non-Potable Water Supply by Potable Water [m^3/day]'},...
                  {'Non-Potable Water Supply by Waste Water Treatment [m^3/day]'},...
                  {'Non-Potable Water Supply by Others [m^3/day]'},...
                  {'% supplied by Potable Water'},...
                  {'% supplied by Waste Water Treatment'},...
                  {'% supplied by Others'},...
                  {'Waste Water Treatment Capacity [m^3/day]'},...
                  {'Capacity Expansion [m^3/day]'},...
                  {'% utilized'}};
cityPower = {{'City'},...
             {'Power Demand [kWh/day]'},...
             {'Power Supply by Others [kWh/day]'},...
             {'% used for Water Production'}};

desalResult = {{'Desal Plant'},...
               {'Water Production Capacity [m^3/day]'},{'Capacity Expansion [m^3/day]'},{'Water Demand Out [m^3/day]'},{'% utilized'},...
               {'Power Generation Capacity [MW]'},{'Capacity Expansion [MW]'},{'Power Demand Out [MW]'},{'% utilized'}};

powerResult = {{'Power Plant'},...
               {'Power Generation Capacity [MW]'},{'Capacity Expansion [MW]'},{'Power Demand Out [MW]'},{'% utilized'}};

for n = 1:nNode
    e = index(cell2mat(setEdge(:,1)),setNode{n,1}); % find a loop associated with node n
    
    netflowOut = netflowOutNode(setEdge,v,xyz,n);
    
    if strcmp(setNode{n,4}(1),'city') == 1 % city
        ii = size(cityPotable,1);
        
        % potable water
        cityPotable{ii+1,1} = setNode{n,2}; % name
        cityPotable{ii+1,2} = -setNode{n,6}(index(flow,'potable water'),1); % potable water demand [m^3/day]
        cityPotable{ii+1,3} = xyz{e}(index(flow,'feed water'),1); % potable water supply by ground water [m^3/day]
        cityPotable{ii+1,4} = -netflowOut(index(flow,'potable water')); % potable water supply by others [m^3/day]
        if cityPotable{ii+1,2} == 0 % no demand, no supply
            supplyGroundWater = 0;
            supplyOthers = 0;
        else
            supplyGroundWater = cityPotable{ii+1,3}/cityPotable{ii+1,2}*100; % [%]
            supplyOthers = cityPotable{ii+1,4}/cityPotable{ii+1,2}*100; % [%]
        end
        cityPotable{ii+1,5} = supplyGroundWater; % percentage of supply by ground water [%]
        cityPotable{ii+1,6} = supplyOthers; % percentage of supply by others [%]
        cityPotable{ii+1,7} = setNode{n,7}(2); % ground water capacity [m^3/day]
        cityPotable{ii+1,8} = xyz{e}(index(flow,'feed water'),3); % ground water capacity expansion [m^3/day]
        if cityPotable{ii+1,7}+cityPotable{ii+1,8} == 0 % no capacity, no utilization
            utilizationGroundWater = 0;
        else
            utilizationGroundWater = cityPotable{ii+1,3}/(cityPotable{ii+1,7}+cityPotable{ii+1,8})*100; % [%]
        end
        cityPotable{ii+1,9} = utilizationGroundWater; % percentage of ground water capacity utilization [%]
        
        % non-potable water
        cityNonPotable{ii+1,1} = setNode{n,2}; % name
        cityNonPotable{ii+1,2} = -setNode{n,6}(index(flow,'non-potable water'),1); % non-potable water demand [m^3/day]
        cityNonPotable{ii+1,3} = xyz{e}(index(flow,'potable water'),1); % non-potable water supply by potable water [m^3/day]
        cityNonPotable{ii+1,4} = xyz{e}(index(flow,'non-potable water'),2)-xyz{e}(index(flow,'potable water'),1); % non-potable water supply by waste water treatment [m^3/day]
        cityNonPotable{ii+1,5} = -netflowOut(index(flow,'non-potable water')); % non-potable water supply by others [m^3/day]
        if cityNonPotable{ii+1,2} == 0 % no demand, no supply
            supplyPotableWater = 0;
            supplyWasteTreatment = 0;
            supplyOthers = 0;
        else
            supplyPotableWater = cityNonPotable{ii+1,3}/cityNonPotable{ii+1,2}*100; % [%]
            supplyWasteTreatment = cityNonPotable{ii+1,4}/cityNonPotable{ii+1,2}*100; % [%]
            supplyOthers = cityNonPotable{ii+1,5}/cityNonPotable{ii+1,2}*100; % [%]
        end
        cityNonPotable{ii+1,6} = supplyPotableWater; % percentage of supply by potable water [%]
        cityNonPotable{ii+1,7} = supplyWasteTreatment; % percentage of supply by waste water treatment [%]
        cityNonPotable{ii+1,8} = supplyOthers; % percentage of supply by others [%]
        cityNonPotable{ii+1,9} = setNode{n,7}(3); % waste water treatment capacity [m^3/day]
        cityNonPotable{ii+1,10} = xyz{e}(index(flow,'waste water'),3); % waste water treatment capacity expansion [m^3/day]
        if cityNonPotable{ii+1,9}+cityNonPotable{ii+1,10} == 0 % no capacity, no utilization
            utilizationWasteWater = 0;
        else
            utilizationWasteWater = xyz{e}(index(flow,'waste water'),1)/(cityNonPotable{ii+1,9}+cityNonPotable{ii+1,10})*100; % [%]
        end
        cityNonPotable{ii+1,11} = utilizationWasteWater; % percentage of waste water treatment capacity utilization [%]
        
        % power
        cityPower{ii+1,1} = setNode{n,2}; % name
        cityPower{ii+1,2} = -setNode{n,6}(index(flow,'electricity'),1); % electricity demand [kWh/day]
        cityPower{ii+1,3} = -netflowOut(index(flow,'electricity')); % electricity supply by others [kWh/day]
        if cityPower{ii+1,2} == 0
            waterProcessPower = 100;
        else
            waterProcessPower = (1-cityPower{ii+1,2}/cityPower{ii+1,3})*100; % [%]
        end
        cityPower{ii+1,4} = waterProcessPower; % percentage of electricity used for water production
    elseif strcmp(setNode{n,4}(1),'desal') == 1 % desal
        ii = size(desalResult,1);
        
        desalResult{ii+1,1} = setNode{n,2}; % name
        
        % potable water
        desalResult{ii+1,2} = setNode{n,7}(1); % potable water capacity [m^3/day]
        desalResult{ii+1,3} = xyz{e}(index(flow,'feed water'),3); % potable water capacity expansion [m^3/day]
        desalResult{ii+1,4} = netflowOut(index(flow,'potable water')); % potable water demand [m^3/day]
        if desalResult{ii+1,2}+desalResult{ii+1,3} == 0 % total capacity
            utilization = 0; % no supply, no utilization
        else
            utilization = desalResult{ii+1,4}/(desalResult{ii+1,2}+desalResult{ii+1,3})*100; % [%]
        end
        desalResult{ii+1,5} = utilization; % percentage of capacity utilization [%]
        
        % electricity
        desalResult{ii+1,6} = setNode{n,7}(2); % power capacity [MW]
        desalResult{ii+1,7} = xyz{e}(index(flow,'power resource'),3)/10^3/24; % power capacity expansion [MW]
        desalResult{ii+1,8} = netflowOut(index(flow,'electricity'))/10^3/24; % power demand out [MW]
        if desalResult{ii+1,6}+desalResult{ii+1,7} == 0 % total capacity
            utilization = 0; % no supply, no utilization
        else
            utilization = desalResult{ii+1,8}/(desalResult{ii+1,6}+desalResult{ii+1,7})*100; % [%]
        end
        desalResult{ii+1,9} = utilization; % percentage of capacity utilization [%]
    elseif strcmp(setNode{n,4}(1),'power') == 1 % power
        ii = size(powerResult,1);
        
        powerResult{ii+1,1} = setNode{n,2}; % name
        
        % electricity
        powerResult{ii+1,2} = setNode{n,7}(1); % power capacity [MW]
        powerResult{ii+1,3} = xyz{e}(index(flow,'power resource'),3)/10^3/24; % power capacity expansion [MW]
        powerResult{ii+1,4} = netflowOut(index(flow,'electricity'))/10^3/24; % power demand out [MW]
        if powerResult{ii+1,2}+powerResult{ii+1,3} == 0 % total capacity
            utilization = 0; % no supply, no utilization
        else
            utilization = powerResult{ii+1,4}/(powerResult{ii+1,2}+powerResult{ii+1,3})*100; % [%]
        end
        powerResult{ii+1,5} = utilization; % percentage of capacity utilization [%]
    end
end
cityResult = {'Potable Water','Non-Potable Water','Power';
              cityPotable,cityNonPotable,cityPower};

end
