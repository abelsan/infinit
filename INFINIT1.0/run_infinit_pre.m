function status = run_infinit_pre(userID,simID,sessionID,cost,CO2,timelimit,optimality)

% TODO: Find a proper place for these values
% System scope values
db_name = 'test_db';
collection = 'test_coll';
inputs.input_filename = 'SSDN_INFINIT_Data.xlsx';

inputs.cost = cost;
inputs.CO2 = CO2;
inputs.time_limit = timelimit; % {seconds}
inputs.optimality_gap = optimality; % {percentage/100}

%% Run the infinit system thought the wrapper

% TODO: Check status value.
[output,status] = infinit_pre(inputs);

% Simulation settings
output.userID = userID;
output.simID = simID; % Simulation ID
output.sessionID = sessionID; % Session ID
output.date_end = datestr(now); % Finish date

%% Store the results on the database

disp('Saving "results" on database');
% TODO: Check status value.
status = store_on_db(db_name, collection, output);


end