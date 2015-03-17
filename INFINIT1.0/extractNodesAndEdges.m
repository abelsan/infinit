function extractNodesAndEdges(userID,sessionID,id,src,inputfile,set_status)

data.date_start = datestr(now); % Start date

% TODO: Find a proper place for these system scope values
db_name = 'test_db';
collection = 'test_coll';

[nodes,edges] = getNodesAndEdgesFromFile(inputfile);

% Simulation settings
data.id = id;
data.userID = userID;
data.sessionID = sessionID; % Session ID
data.src = src;
data.inputfile = inputfile;
data.status = set_status;

% Save results

data.outputs.nodes = getInitialNodes(nodes)';
data.outputs.edges = getInitialEdges(nodes,edges)';
data.date_end = datestr(now); % Finish date

%% Store the results on the database

% TODO: Check exit status
exit_status = store_on_db(db_name, collection, data);


end