%% Setting Up INFINIT MILP
% Interdependent Network Flows with Induced Internal Transformation (INFINIT)
% Generalized Multi-Commodity Network Flow (GMCNF)
%   min     J = cxoi'*xoi+cyoi'*yoi+cz'*z
%   s.t.:   sum(Ao*xo)-sum(Ai*xi) <= bc  for each node
%           xi = B*xo                    for each edge
%           Coi*xoi <= 0                 for each edge
%           0 <= xoi <= uoi+yoi          for each edge
%           0 <= xoi <= M*z              for each edge
%           loi <= xoi                   for each edge
%           0 <= yoi                     for each edge
%           z binary {0,1}               for each edge
% Inputs
%   Flow Vector Size: v (number of flow elements/commodities)
%   Binary Vector Size: w (number of binary decisions)
%   Objective Function Weight: W
%   Number of Edges: E
%   Objective Function Coefficients: cx,cy,cz
% Outputs
%   INFINIT MILP Parameters: fall,f

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [fall,f] = setupObjFun(v,w,W,E,cx,cy,cz)

%% Parameters
exyz = 4*v+w; % number of variables for each edge
fm = sparse(exyz*E,size(W,1));

for e = 1:E
    xo = exyz*(e-1)+1; % outflow from node i: x+
    xi = xo+v; % inflow into node j: x-
    yo = xi+v; % capacity expansion for outflow: y+
    yi = yo+v; % capacity expansion for inflow: y-
    z = yi+v; % whether in use or not: z
    
    % fm(cx,cy,cz) -> f
    % J = cxoi'*xoi+cyoi'*yoi+cz'*z
    for k = 1:size(W,1)
        fm(xo:xo+v-1,k) = cx{e}{k}(:,1); % x+
        fm(xi:xi+v-1,k) = cx{e}{k}(:,2); % x-
        fm(yo:yo+v-1,k) = cy{e}{k}(:,1); % y+
        fm(yi:yi+v-1,k) = cy{e}{k}(:,2); % y-
        fm(z:z+w-1,k) = cz{e}{k}(:,1); % z
    end
end

fall = fm;
f = fall*W; % weighted sum

end
