function res = data2json(obj_name,data)
% Convert Matlab data to JSON format.
% Input data can be anything, from an array to a cell.
%

addpath('../matlab/jsonlab');

import com.mongodb.util.JSON;
import com.mongodb.BasicDBObject;


a = savejson(obj_name,data);

res(1) = JSON.parse(a);

end
