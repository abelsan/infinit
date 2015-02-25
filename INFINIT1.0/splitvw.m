%% Splitting Vector x into Cell [xo xi yo yi z]
% |1| -> |1 3 5 7 9|
% |2|    |2 4 6 8 a|
% |3|
% |4|
% |5|
% |6|
% |7|
% |8|
% |9|
% |a|

% Inputs
%   Vector: x
%   Size of Variable Vector: v
%   Size of Binary Variable Vector: w
%   Mapping Matrix from Flow to Binary: vw
%   Number of Groups: G

% Outputs
%   Split Cell: [split]

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [split] = splitvw(x,v,w,vw,G)

lx = size(x,1); % length of vector x
xc = mat2cell(x,lx/G*ones(1,G));

split = cell(G,1);
for i =1:G
    split{i}(:,1) = xc{i}(1:v,1);
    split{i}(:,2) = xc{i}(v+1:2*v,1);
    split{i}(:,3) = xc{i}(2*v+1:3*v,1);
    split{i}(:,4) = xc{i}(3*v+1:4*v,1);
    split{i}(:,5) = vw*xc{i}(4*v+1:4*v+w,1);
end

end
