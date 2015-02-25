function exit_status = store_on_db(db_name, collection, data)
% Store data on MongoDB.
%
%
% Matlab version works.
% Octave version not working.
%

import com.mongodb.Mongo;

m = Mongo(); % connect to local db

db = m.getDB(db_name); % get db object

coll = db.getCollection(collection);

doc = data2json('result_network', data);

coll.insert(doc);

m.close();

exit_status = 1;


end
