%% Drawing Edges Used
% Inputs
%   Set of Nodes: setNode
%   Set of Edges: setEdge
%   Optimized Result: xyz
% Outputs
%   Edges Used

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function out = getResultEdges(setNode,setEdge,xyz)

nEdge = size(setEdge,1); % number of edges
tol = 2e-5;
out = {};
count = 1;

for e = 1:nEdge
    if setEdge{e,1} < 0 % if it is a bi-directional edge
        netxoi = (xyz{e-1}(:,1)+xyz{e-1}(:,2))/2-(xyz{e}(:,1)+xyz{e}(:,2))/2;
%         if max(abs(netxoi(5:6))) > tol
%             i = setEdge{e-1,4}(1);
%             j = setEdge{e-1,4}(2);
%             lat = [setNode{i,4}(1) setNode{j,4}(1)];
%             lon = [setNode{i,4}(2) setNode{j,4}(2)];
%             geoshow(lat,lon,'LineWidth',2,'Color','y');
%         end
        if max(abs(netxoi(1:4))) > tol
            i = setEdge{e-1,4}(1);
            j = setEdge{e-1,4}(2);
            lat = [setNode{i,5}(1) setNode{j,5}(1)];
            lon = [setNode{i,5}(2) setNode{j,5}(2)];
            if strcmp(setEdge{e,3}(2),'existing') == 1      % Blue
%                 geoshow(lat,lon,'LineWidth',2,'Color',[0 0 0.7]);
                % Water pipeline (in use)
                out(count,:) = { setEdge{e,3}(1), setEdge{e,3}(2), lat(1), lon(1), lat(2), lon(2)};
                count = count + 1;
            else    % Cyan
%                 geoshow(lat,lon,'LineWidth',2,'Color',[0 0.7 1]);
                % Water pipeline (new)
                out(count,:) = { setEdge{e,3}(1), 'new', lat(1), lon(1), lat(2), lon(2)};
                count = count + 1;                
            end
        else
            if strcmp(setEdge{e,3}(1),'pipeline') == 1 && strcmp(setEdge{e,3}(2),'existing') == 1
                i = setEdge{e,4}(1);
                j = setEdge{e,4}(2);
                lat = [setNode{i,5}(1) setNode{j,5}(1)];
                lon = [setNode{i,5}(2) setNode{j,5}(2)];
%                 geoshow(lat,lon,'LineWidth',1.5,'Color','r');
                % Water pipeline (not in use)
                out(count,:) = { setEdge{e,3}(1), 'unused', lat(1), lon(1), lat(2), lon(2)};
                count = count + 1;                                
            end
        end
    end
end

end