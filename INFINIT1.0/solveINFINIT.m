%% Solve INFINIT MILP
fprintf('Solving INFINIT MILP... \n');

%% Options
% options = cplexoptimset;
% options.Diagnostics = 'on';
% % options.MaxIter = 100000; % iteration limit: 100000 times
% options.MaxNodes = 100000; % node limit: 100000 nodes
% options.MaxTime = 10; % computation time limit: 1000 seconds
% % options.Simplex = 'on';
% % options.TolFun = 1.0000e-03; % default: 1.0000e-06
% % options.TolRLPFun = 1.0000e-03; % default: 1.0000e-06
% ----------
options = cplexoptimset('cplex');
options.Diagnostics = 'on';
% options.mip.tolerances.mipgap = 0.05;
options.timelimit = 3;
options.parameter2009 = 0.03; % optimality gap

%% MILP Solver (CPLEX)
[x,J,exitflag,output] = cplexmilp(f,Aineq,bineq,Aeq,beq,[],[],[],lb,[],ctype,[],options);
fx = fall'*x;
xyz = splitvw(x,v,w,vw,E);

%% Results
% Objective Function
fprintf('-------------------- \n');
fprintf('Total CAPEX/OPEX: \t %3.1f billion [USD/year] \n',(fx(index(KPI,'CAPEX'))+fx(index(KPI,'OPEX')))/10^9);
fprintf('Total CAPEX: \t\t %3.1f billion [USD/year] \n',fx(index(KPI,'CAPEX'))/10^9);
fprintf('Total OPEX: \t\t %3.1f billion [USD/year] \n',fx(index(KPI,'OPEX'))/10^9);
fprintf('Total CO2 emission: \t\t %3.1f million [mt/year] \n',fx(index(KPI,'CO2'))/10^9);
fprintf('Total potable water produced: \t %3.0f [Mm^3/year] \n',fx(index(KPI,'potable water'))*365/10^6);
fprintf('Total electricity produced: \t %3.0f [GWh/year] \n',fx(index(KPI,'electricity'))*365/10^6);

% Save Workspace
save('Result.mat');

% Results
[cityResult,desalResult,powerResult] = listResult(setNode,setEdge,flow,v,xyz);

% Results Drawing
% drawResult(setNode,setEdge,flow,xyz,weightCost,weightCO2);
