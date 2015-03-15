var http = require('http');
var exec = require('child_process').exec;
var express = require('express');
var app = express();
var url = require('url');

// Platform parameters
var in_userID,
	in_simID,
	in_sessionID;

// Model input parameters
var in_cost,
	in_co2,
	in_timelimit,
	in_optimality;

var PORT = 8080;

app.get('/output', function(req, res) {

	var url_parts = url.parse(req.url,true);

	in_userID = url_parts.query.userID;
	in_simID = url_parts.query.simID;
	in_sessionID = url_parts.query.sessionID;
	in_cost = url_parts.query.cost;
	in_co2 = url_parts.query.co2;
	in_timelimit = url_parts.query.timelimit;
	in_optimality = url_parts.query.optimality;

	//var cmd =  "octave --silent --eval 'runcode("+in_Mdr+","+in_Xf+","+in_Cp+","+in_Tn+","+in_To+","+in_Ts+","+in_Tf+","+in_n+","+in_Vb+","+in_Vvn+","+in_Cd+ ")'";
	var cmd = 'matlab -nodesktop -nosplash -nodisplay -logfile log.txt' +
			' -r ' + '"' +
				"addpath('../INFINIT1.0');" +
				'run_infinit_pre('+
					in_userID+','+
					"'"+in_simID+"',"+
					"'"+in_sessionID+"',"+
					in_cost+','+
					in_co2+','+
					in_timelimit+','+
					in_optimality+
				');'+
				'exit;"';

console.log("cmd: " + cmd);

	exec(cmd, function (error, stdout, stderr) {

		var msg = {};
		var files = [];

console.log("Loading results from DB");

		var findDocuments = function(db, callback) {
			// Get the documents collection
			var collection = db.collection('test_coll');

console.log("searching: " + 'userID:' + in_userID);
			// Find the simulation results
			collection.find({'userID':Number(in_userID), 'simID':in_simID}).toArray(function(err, docs) {
				assert.equal(err, null);
				assert.equal(1, docs.length); // We expect only 1 document.
				console.log("Found the following " + docs.length + " records:");
				console.dir(docs);
				callback(docs);
			});
		};

		var MongoClient = require('mongodb').MongoClient,
			assert = require('assert');

		// Connection URL
		var db_url = 'mongodb://localhost:27017/test_db';
		// Use connect method to connect to the Server
		MongoClient.connect(db_url, function(err, db) {
			assert.equal(null, err);
			console.log("Connected correctly to server");

			findDocuments(db, function(docs) {
				res.send({
		  			'msg': {
		  				'data':docs[0],
		  				'files':files ,
		  				'stdout':stdout ,
		  				'stderr':stderr
		  			}
		  		});

				db.close();
			});
		});

		console.log('stdout: ' + stdout);
		console.log('stderr: ' + stderr);
	});

});

app.get('/test', function(req, res) {
	console.log("Loading results from DB");

	var findDocument = function(db, callback) {
		// Get the documents collection
		var collection = db.collection('test_coll');
		// Find the simulation results
		collection.findOne({},{}, function(err, doc) {
			assert.equal(err, null);
			assert.notEqual(doc, null); // We expect only 1 document.
			console.log("Found the following records:");
			console.dir(doc);
			callback(doc);
		});
	};

	var MongoClient = require('mongodb').MongoClient,
		assert = require('assert');

	// Connection URL
	var db_url = 'mongodb://localhost:27017/test_db';
	// Use connect method to connect to the Server
	MongoClient.connect(db_url, function(err, db) {
		assert.equal(null, err);
		console.log("Connected correctly to server");

		findDocument(db, function(doc) {
			res.send({
	  			'msg': {
	  				'data':doc,
	  				'files':"none" ,
	  				'stdout':"Nothing" ,
	  				'stderr':"Nothing"
	  			}
	  		});

			db.close();
		});
	});
});


app.get('/initial_network', function(req, res) {
	console.log("Loading results from DB");

	var findDocument = function(db, callback) {
		// Get the documents collection
		var collection = db.collection('test_coll');
		// Find the simulation results
		collection.findOne({'id':'initial_network'}, {}, function(err, doc) {
			assert.equal(err, null);
			assert.notEqual(doc, null); // We expect only 1 document.
			console.log("Found the following records:");
			console.dir(doc);
			callback(doc);
		});
	};

	var MongoClient = require('mongodb').MongoClient,
		assert = require('assert');

	// Connection URL
	var db_url = 'mongodb://localhost:27017/test_db';
	// Use connect method to connect to the Server
	MongoClient.connect(db_url, function(err, db) {
		assert.equal(null, err);
		console.log("Connected correctly to server");

		findDocument(db, function(doc) {
			res.send({
	  			'msg': {
	  				'data': doc,
	  				'files':"none" ,
	  				'stdout':"Nothing" ,
	  				'stderr':"Nothing"
	  			}
	  		});

			db.close();
		});
	});
});


// Serve the web files, like 'index.html' and 'style.css'.
app.use("/", express.static(__dirname + "/../public"));

///////////
// Important!
// Set this directory path properly:
// It is where Sencha files are:
//		(the relative path to the directory "ext-5.1.0-gpl")
// app.use("/sencha", express.static(__dirname + "/../../extjs/ext-5.1.0-gpl"));

app.listen(PORT);

console.log('listening on port ' + PORT);




