%% Laying Out Nodes Used
% Inputs
%   Set of Nodes: setNode
%   Set of Edges: setEdge
%   Flow Vector: flow
%   Optimized Result: xyz
% Outputs
%   Nodes Used

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function out = getResultNodes(setNode,setEdge,flow,xyz)

%% Settings
nNode = size(setNode,1);
listODID = cell2mat(setEdge(:,1)); % list of origin-destination ID
tol = 1e-5;
minSize = 5;
stepSizePopulation = 1500000;
stepSizeWater = 500000;
stepSizePower = 1500;

out = {};
count = 1;


for i = 1:nNode
    n = nNode+1-i; % reverse order
    e = index(listODID,setNode{n,1}); % find a loop associated with node n
    
    lat = setNode{n,5}(1);
    lon = setNode{n,5}(2);

    if strcmp(setNode{n,4}(1),'city') == 1
        if xyz{e}(index(flow,'waste water'),1) < tol % cities without wastewater treatment -> red
            condition{1} = 'without_wastewater_treatment';
%             geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
%                                                     'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','r',...
%                                                     'MarkerSize',2*fix(setNode{n,7}(1)/stepSizePopulation)+minSize);
        else % cities with wastewater treatment -> green
            condition{1} = 'with_wastewater_treatment';
%             geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
%                                                     'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','g',...
%                                                     'MarkerSize',2*fix(setNode{n,7}(1)/stepSizePopulation)+minSize);
        end
        value = 2*fix(setNode{n,7}(1)/stepSizePopulation)+minSize;
        capacity = setNode{n,7}(1);        
    elseif strcmp(setNode{n,4}(1),'desal') == 1 % desal plants -> blue
        condition = setNode{n,4}(2); % 'existing' or 'candid'
        value = 2*fix(xyz{e}(index(flow,'feed water'),1)/stepSizeWater)+minSize;
        capacity = xyz{e}(index(flow,'feed water'),1);

%         if strcmp(setNode{n,4}(2),'existing') == 1
%             geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
%                                                     'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','b',...
%                                                     'MarkerSize',2*fix(xyz{e}(index(flow,'feed water'),1)/stepSizeWater)+minSize);
%         elseif strcmp(setNode{n,4}(2),'candid') == 1
%             geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
%                                                     'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','b',...
%                                                     'MarkerSize',2*fix(xyz{e}(index(flow,'feed water'),1)/stepSizeWater)+minSize);
%         end
    elseif strcmp(setNode{n,4}(1),'power') == 1 % power plants -> yellow
        condition = setNode{n,4}(1);
        value = 2*fix(xyz{e}(index(flow,'power resource'),1)/10^3/24/stepSizePower)+minSize;
        capacity = xyz{e}(index(flow,'power resource'),1)/10^3/24;
        
%         geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
%                                                 'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','y',...
%                                                 'MarkerSize',2*fix(xyz{e}(index(flow,'power resource'),1)/10^3/24/stepSizePower)+minSize);
    end

    
%   output format:
%           node_type, 
%           condition, 
%           lat, 
%           lon, 
%           value, 
%           node_capacity, 
%           node_id, 
%           node_name, 
%           Region,

%     out(count,:) = { setNode{n,4}(1), condition, lat, lon, value, capacity };
    out(count,:) = { setNode{n,4}(1), condition, lat, lon, value, capacity, setNode{n,1}, setNode{n,2}, setNode{n,3} };
    count = count + 1;
end

% labeling nodes
% labelNodes;
% legendResult;

end
