%% Laying Out Nodes
% Inputs
%   Set of Nodes: setNode
% Outputs
%   Nodes

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [] = layoutNodes(setNode)

nNode = size(setNode,1);

minSize = 5;
stepSizePopulation = 1500000;
stepSizeWater = 300000;
stepSizePower = 1500;

for i = 1:nNode
    n = nNode+1-i; % reverse order
    if strcmp(setNode{n,4}(1),'city') == 1
        if setNode{n,7}(3) == 0 % cities without wastewater treatment -> red
            geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
                                                    'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','r',...
                                                    'MarkerSize',2*fix(setNode{n,7}(1)/stepSizePopulation)+minSize);
        else % cities with wastewater treatment -> green
            geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
                                                    'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','g',...
                                                    'MarkerSize',2*fix(setNode{n,7}(1)/stepSizePopulation)+minSize);
        end
    elseif strcmp(setNode{n,4}(1),'desal') == 1 % desal plants -> blue
        if strcmp(setNode{n,4}(2),'existing') == 1
        geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
                                                'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','b',...
                                                'MarkerSize',2*fix(setNode{n,7}(1)/stepSizeWater)+minSize);
        elseif strcmp(setNode{n,4}(2),'candid') == 1
        geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
                                                'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor',[0.7 0.7 0.7],...
                                                'MarkerSize',2*fix(setNode{n,7}(1)/stepSizeWater)+minSize);
        end
    elseif strcmp(setNode{n,4}(1),'power') == 1 % power plants -> yellow
        geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
                                                'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','y',...
                                                'MarkerSize',2*fix(setNode{n,7}(1)/stepSizePower)+minSize);
    end
end

% labeling nodes
labelNodes;
legend;

end
