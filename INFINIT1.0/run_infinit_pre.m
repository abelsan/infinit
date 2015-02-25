function status = run_infinit_pre(userID,simID,cost,CO2,timelimit,optimality)

%% Set structure input values for the infinit wrapper function:
settings.userID = userID;
settings.simID = simID;

% TODO: Find a proper place for these values
% System scope values
settings.db_name = 'test_db';
settings.collection = 'test_coll';
inputs.input_filename = 'SSDN_INFINIT_Data.xlsx';

inputs.cost = cost;
inputs.CO2 = CO2;
inputs.time_limit = timelimit; % {seconds}
inputs.optimality_gap = optimality; % {percentage/100}

%% Run the infinit system thought the wrapper
% TODO: Check status value.
[output,status] = infinit_pre(settings, inputs);

%% Store the results on the database
% TODO: Check status value.
status = store_on_db(settings.db_name, settings.collection, output);


exit
end