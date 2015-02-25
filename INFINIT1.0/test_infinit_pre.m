clear;
clc;

settings.userID = 1;
settings.simID = '010a';
settings.db_name = 'test_db';
settings.collection = 'test_coll';


inputs.input_filename = 'SSDN_INFINIT_Data.xlsx';
inputs.cost = 1.0;
inputs.CO2 = 0.0;
inputs.time_limit = 30; % {seconds}
inputs.optimality_gap = 0.03; % {percentage/100}

infinit_pre(settings, inputs);
