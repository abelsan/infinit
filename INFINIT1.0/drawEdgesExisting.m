%% Drawing Existing Edges
% Inputs
%   Set of Nodes: setNode
%   Set of Edges: setEdge
% Outputs
%   Existing Edges

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [] = drawEdgesExisting(setNode,setEdge)

nEdge = size(setEdge,1); % number of edges

for e = 1:nEdge
    if strcmp(setEdge{e,3}(1),'pipeline') == 1 && strcmp(setEdge{e,3}(2),'existing') == 1
        i = setEdge{e,4}(1);
        j = setEdge{e,4}(2);
        lat = [setNode{i,5}(1) setNode{j,5}(1)];
        lon = [setNode{i,5}(2) setNode{j,5}(2)];
        geoshow(lat,lon,'LineWidth',1.5,'Color','r');
%     elseif strcmp(setEdge{e,3}(1),'pipeline') == 1 && strcmp(setEdge{e,3}(2),'candid') == 1
%         i = setEdge{e,4}(1);
%         j = setEdge{e,4}(2);
%         lat = [setNode{i,5}(1) setNode{j,5}(1)];
%         lon = [setNode{i,5}(2) setNode{j,5}(2)];
%         geoshow(lat,lon,'LineWidth',0.5,'LineStyle',':','Color','k');
    end
end

end
