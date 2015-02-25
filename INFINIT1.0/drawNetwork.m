%% Drawing Network
% Inputs
%   Set of Nodes: setNode
%   Set of Edges: setEdge
% Outputs
%   Network

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [] = drawNetwork(setNode,setEdge)

% KSA map
figure;
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
drawEdges(setNode,setEdge);

% laying out nodes
layoutNodes(setNode);

end
