%% Drawing Result
% Inputs
%   Set of Nodes: setNode
%   Set of Edges: setEdge
%   Flow Vector: flow
%   Optimized Result: xyz
%   Weights: weightCost,weightCO2
% Outputs
%   Resulting Network

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [] = drawResult(setNode,setEdge,flow,xyz,weightCost,weightCO2)

% KSA map
% figure;
set(gcf,'Position',get(0,'Screensize')); % maximize figure

% projection
% 1: mercator
% 2: sphere
projection = 1;

latlim = [12 34];
lonlim = [34 60];
waterColor = [0.7 0.7 0.8];

if projection == 1
    ax = axesm('MapProjection','mercator',...
               'MapLatLimit',latlim,'MapLonLimit',lonlim,...
               'FFaceColor',waterColor,...
               'Frame','on','Grid','off',...
               'MeridianLabel','off','ParallelLabel','off');
    axis off;
    geoshow(ax,'TM_WORLD_BORDERS-0.3.shp','FaceColor','white');
    geoshow('worldlakes.shp','FaceColor',waterColor);
elseif projection == 2
    worldmap('saudi arabia');
    geoshow('TM_WORLD_BORDERS-0.3.shp','FaceColor','white');
end

% drawing edges
% drawEdgesUsed(setNode,setEdge,xyz);
drawEdgesExisting(setNode,setEdge);
drawEdgesUsedWater(setNode,setEdge,xyz);

% laying out nodes
% layoutNodes(setNode);
layoutNodesUsed(setNode,setEdge,flow,xyz);

% indicating objective function weights
% weights = sprintf('Minimizing Cost %d%% & CO2 %d%%',round(weightCost*100),round(weightCO2*100));
% textm(14.3,50.1,weights,'Color','w','FontSize',12,'FontWeight','bold','FontName','Calibri');
weightCostS = sprintf('%1.2f',weightCost);
weightCO2S = sprintf('%1.2f',weightCO2);
textm(14.4,54.5,'Weights','Color','k','FontSize',12,'FontWeight','bold','FontName','Calibri');
textm(14.4,51.9,'Cost','Color','k','FontSize',12,'FontWeight','bold','FontName','Calibri');
textm(14.4,58.0,'CO2','Color','k','FontSize',12,'FontWeight','bold','FontName','Calibri');
textm(14.9,52.0,weightCostS,'Color','k','FontSize',10,'FontName','Calibri');
textm(14.9,58.05,weightCO2S,'Color','k','FontSize',10,'FontName','Calibri');
geoshow([13.4-0.5 13.4+0.5],[52.5 52.5],'LineWidth',3,'Color','k');
geoshow([13.4-0.5 13.4+0.5],[58.5 58.5],'LineWidth',3,'Color','k');
geoshow([13.4 13.4],[52.5 58.5],'LineWidth',3,'Color','k');
geoshow(13.4,52.5+(58.5-52.5)*weightCO2,'DisplayType','multipoint',...
                                        'Marker','o','LineWidth',2.5,'MarkerEdgeColor',[0 0.7 1],'MarkerFaceColor',[0 1 0.7],...
                                        'MarkerSize',12);
geoshow(13.4,52.5+(58.5-52.5)*weightCO2,'DisplayType','multipoint',...
                                        'Marker','x','LineWidth',2.5,'MarkerEdgeColor',[0 0.7 1],...
                                        'MarkerSize',12);

end
