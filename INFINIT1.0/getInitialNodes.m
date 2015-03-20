%% Laying Out Nodes
% Inputs
%   Set of Nodes: setNode
% Outputs
%       Nodes
%   Format:
%           node_type, 
%           condition, 
%           lat, 
%           lon, 
%           value, 
%           0, 
%           node_id, 
%           node_name, 
%           Region,


% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function out = getInitialNodes(setNode)

nNode = size(setNode,1);

minSize = 5;
stepSizePopulation = 1500000;
stepSizeWater = 300000;
stepSizePower = 1500;

out = {};
count = 1;

for i = 1:nNode
    n = nNode+1-i; % reverse order
    
    lat = setNode{n,5}(1);
    lon = setNode{n,5}(2);
    
    if strcmp(setNode{n,4}(1),'city') == 1
        if setNode{n,7}(3) == 0 % cities without wastewater treatment -> red
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
    elseif strcmp(setNode{n,4}(1),'desal') == 1 % desal plants -> blue
        condition = setNode{n,4}(2); % 'existing' or 'candid'
        value = 2*fix(setNode{n,7}(1)/stepSizeWater)+minSize;
%         if strcmp(setNode{n,4}(2),'existing') == 1
    %         geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
    %                                                 'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','b',...
    %                                                 'MarkerSize',2*fix(setNode{n,7}(1)/stepSizeWater)+minSize);
%         elseif strcmp(setNode{n,4}(2),'candid') == 1
%             geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
%                                                     'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor',[0.7 0.7 0.7],...
%                                                     'MarkerSize',2*fix(setNode{n,7}(1)/stepSizeWater)+minSize);
%         end
    elseif strcmp(setNode{n,4}(1),'power') == 1 % power plants -> yellow
        condition = setNode{n,4}(1);
        value = 2*fix(setNode{n,7}(1)/stepSizePower)+minSize;
%             geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
%                                                     'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','y',...
%                                                     'MarkerSize',2*fix(setNode{n,7}(1)/stepSizePower)+minSize);
    end

    capacity = setNode{n,7}(1);
    
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


end
