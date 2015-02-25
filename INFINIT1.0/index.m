%% Returning Index
% Inputs
%   Flow Vector: flow
%   Label to Find: label
% Outputs
%   Index: ind

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [ind] = index(flow,label)

ind = find(ismember(flow,label),1);

end
