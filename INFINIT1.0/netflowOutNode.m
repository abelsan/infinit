%% Requesting Net Flow Out from Node
% Inputs
%   Set of Edges: setEdge
%   Size of Flow Vector: v
%   Optimized Result: xyz
%   Node of Interest: n
% Outputs
%   Net Flow from Node n: netflow

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [netflowOut] = netflowOutNode(setEdge,v,xyz,n)

nEdge = size(setEdge,1); % number of edges

netflowOut = zeros(v,1);
for e = 1:nEdge
    if setEdge{e,4}(1) == n && setEdge{e,4}(2) ~= n % if outflow from n
        Ao = setEdge{e,8};
        netflowOut = netflowOut+Ao*xyz{e}(:,1);
    end
    if setEdge{e,4}(1) ~= n && setEdge{e,4}(2) == n % if inflow into n
        Ai = setEdge{e,9};
        netflowOut = netflowOut-Ai*xyz{e}(:,2);
    end
end

end
