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
%   Mapping Matrix from Flow to Binary: vw
%   Objective Function Weight: W
%   Number of Nodes: N
%   Number of Edges: E
%   Origin and Destination of Each Edge: OD
%   Objective Function Coefficients: cx,cy,cz
%   Network Constraints: Ao,Ai,bc,B,Co,Ci,lo,li,uo,ui
% Outputs
%   INFINIT MILP Parameters: fall,f,Aineq,bineq,Aeq,beq,lb

% Programmer: Takuto Ishimatsu
% Advisor: Olivier de Weck

function [fall,f,Aineq,bineq,Aeq,beq,lb] = setupINFINIT(v,w,vw,W,N,E,OD,cx,cy,cz,Ao,Ai,bc,B,Co,Ci,lo,li,uo,ui)

%% Parameters
exyz = 4*v+w; % number of variables for each edge
fm = sparse(exyz*E,size(W,1));
Am = sparse(v*N,exyz*E);
Bm = sparse(v*E,exyz*E);
Cm = sparse([]);
Um = sparse(2*v*E,exyz*E);
um = sparse(2*v*E,1);
Mm = sparse(2*v*E,exyz*E);
lm = sparse(exyz*E,1);
bigM = 10^8;

for e = 1:E
    i = OD{e}(1); % origin
    j = OD{e}(2); % destination
    
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
    
    % Am(Ao,Ai) -> Aineq
    % sum(Ao*xo)-sum(Ai*xi) <= bc  for each node
    Am(v*(i-1)+1:v*i,xo:xo+v-1) = Ao{e};
    Am(v*(j-1)+1:v*j,xi:xi+v-1) = -Ai{e};
    
    % Bm(B) -> Aeq
    % B*xo-I*xi = 0  for each edge
    Bm(v*(e-1)+1:v*e,xo:xo+v-1) = B{e};
    Bm(v*(e-1)+1:v*e,xi:xi+v-1) = sparse(-eye(v));
    
    % Cm(Co,Ci) -> Aineq
    % Coi*xoi <= 0  for each edge
    ro = size(Co{e},1);
    if ro ~= 0
        Cm(end+1:end+ro,xo:xo+v-1) = sparse(Co{e});
    end
    ri = size(Ci{e},1);
    if ri ~= 0
        Cm(end+1:end+ri,xi:xi+v-1) = sparse(Ci{e});
    end
    
    % Um -> Aineq
    % um -> bineq
    % 0 <= xoi <= uoi+yoi  for each edge
    Um(2*v*(e-1)+1:2*v*(e-1)+v,xo:xo+v-1) = sparse(eye(v));
    Um(2*v*(e-1)+1:2*v*(e-1)+v,yo:yo+v-1) = sparse(-eye(v));
    Um(2*v*(e-1)+v+1:2*v*e,xi:xi+v-1) = sparse(eye(v));
    Um(2*v*(e-1)+v+1:2*v*e,yi:yi+v-1) = sparse(-eye(v));
    um(2*v*(e-1)+1:2*v*(e-1)+v,1) = uo{e};
    um(2*v*(e-1)+v+1:2*v*e,1) = ui{e};
    
    % Mm -> Aineq
    % 0 <= xoi <= M*z  for each edge
    Mm(2*v*(e-1)+1:2*v*(e-1)+v,xo:xo+v-1) = sparse(eye(v));
    Mm(2*v*(e-1)+1:2*v*(e-1)+v,z:z+w-1) = sparse(-bigM*vw);
    Mm(2*v*(e-1)+v+1:2*v*e,xi:xi+v-1) = sparse(eye(v));
    Mm(2*v*(e-1)+v+1:2*v*e,z:z+w-1) = sparse(-bigM*vw);
    
    % lm(lo,li) -> lb
    % loi <= xoi  for each edge
    lm(xo:xo+v-1,1) = lo{e};
    lm(xi:xi+v-1,1) = li{e};
end

fall = fm;
f = fall*W; % weighted sum
Aineq = [Am;Cm;Um;Mm];
bineq = [cell2mat(bc);sparse(size(Cm,1),1);um;sparse(size(Mm,1),1)];
Aeq = Bm;
beq = sparse(size(Aeq,1),1);
lb = lm;

end
