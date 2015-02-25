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

function [] = layoutNodesUsed(setNode,setEdge,flow,xyz)

%% Settings
nNode = size(setNode,1);
listODID = cell2mat(setEdge(:,1)); % list of origin-destination ID
tol = 1e-5;
minSize = 5;
stepSizePopulation = 1500000;
stepSizeWater = 500000;
stepSizePower = 1500;

for i = 1:nNode
    n = nNode+1-i; % reverse order
    e = index(listODID,setNode{n,1}); % find a loop associated with node n
    if strcmp(setNode{n,4}(1),'city') == 1
        if xyz{e}(index(flow,'waste water'),1) < tol % cities without wastewater treatment -> red
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
                                                'MarkerSize',2*fix(xyz{e}(index(flow,'feed water'),1)/stepSizeWater)+minSize);
        elseif strcmp(setNode{n,4}(2),'candid') == 1
        geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
                                                'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','b',...
                                                'MarkerSize',2*fix(xyz{e}(index(flow,'feed water'),1)/stepSizeWater)+minSize);
        end
    elseif strcmp(setNode{n,4}(1),'power') == 1 % power plants -> yellow
        geoshow(setNode{n,5}(1),setNode{n,5}(2),'DisplayType','multipoint',...
                                                'Marker','o','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','y',...
                                                'MarkerSize',2*fix(xyz{e}(index(flow,'power resource'),1)/10^3/24/stepSizePower)+minSize);
    end
end

% labeling nodes
labelNodes;
legendResult;

end
