var http = require('http');
var exec = require('child_process').exec;
var express = require('express');
var app = express();
var url = require('url');
var multer = require('multer');

var PORT = 8080;

// Platform parameters
var in_userID,
	in_simID,
	in_sessionID;

// Model input parameters
var in_cost,
	in_co2,
	in_timelimit,
	in_optimality;

// Directories
var model_dir = '../INFINIT1.0';
var inputs_dir = '../INFINIT1.0/inputs';


app.get('/output', function(req, res) {

	var url_parts = url.parse(req.url,true);

	in_userID = Number(url_parts.query.userID);
	in_simID = url_parts.query.simID;
	in_sessionID = url_parts.query.sessionID;
	in_cost = url_parts.query.cost;
	in_co2 = url_parts.query.co2;
	in_timelimit = url_parts.query.timelimit;
	in_optimality = url_parts.query.optimality;

	//var cmd =  "octave --silent --eval 'runcode("+in_Mdr+","+in_Xf+","+in_Cp+","+in_Tn+","+in_To+","+in_Ts+","+in_Tf+","+in_n+","+in_Vb+","+in_Vvn+","+in_Cd+ ")'";
	var cmd = 'matlab -nodesktop -nosplash -nodisplay -logfile log.txt' +
			' -r ' + '"' +
				"addpath('"+model_dir+"');" +
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
			collection.find({'userID':in_userID, 'simID':in_simID}).toArray(function(err, docs) {
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

	var url_parts = url.parse(req.url,true);

	var in_userID = Number(url_parts.query.userID);
	var in_sessionID = url_parts.query.sessionID;
	var in_src = url_parts.query.src; // values: 'src_default' || 'src_new_file'
	var in_inputfile = url_parts.query.inputfile; //  =Default

	var findDocument = function(db, query_obj, callback) {
		// Get the documents collection
		var collection = db.collection('test_coll');
		// Find the simulation results
		collection.findOne(query_obj, {},
			function(err, doc) {
				assert.equal(err, null);
				// assert.notEqual(doc, null); // We expect only 1 document.
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

		findDocument(db,
			{
				'id': 'initial_network',
				'userID': in_userID,
				'sessionID': in_sessionID,
				// 'src': in_src,
				'status': 'active',
			},
			function(doc) {
				if ( doc !== null ) { // Respond Data on the DB.
					res.send({
			  			'msg': {
			  				'data': doc,
			  				'files':"none" ,
			  				'stdout':"Nothing" ,
			  				'stderr':"Nothing"
			  			}
			  		});

					db.close();
				} else { // Load data on DB from file
					if ( in_src === 'src_default' ) { // Use Default file
						in_inputfile = inputs_dir+'/default/'+'SSDN_INFINIT_Data.xlsx';
						//var cmd =  "octave --silent --eval 'runcode("+in_Mdr+","+in_Xf+","+in_Cp+","+in_Tn+","+in_To+","+in_Ts+","+in_Tf+","+in_n+","+in_Vb+","+in_Vvn+","+in_Cd+ ")'";
						var cmd = 'matlab -nodesktop -nosplash -nodisplay -logfile log.txt' +
							' -r ' + '"' +
								"addpath('"+model_dir+"');" +
								'extractNodesAndEdges('+
									in_userID+','+
									"'"+in_sessionID+"',"+
									"'initial_network',"+
									"'"+in_src+"',"+
									"'"+in_inputfile+"',"+
									"'active'"+//","+
								');'+
								'exit;"';
						console.log("cmd: " + cmd);

						// Dump default file on DB
						exec(cmd, function (error, stdout, stderr) {
							// Retrieve data from DB and send it as response.
							findDocument(db,
							{
								'id': 'initial_network',
								'userID': in_userID,
								'sessionID': in_sessionID,
								// 'src': in_src,
								'status': 'active',
							},
							function(doc) {
								if ( doc !== null ) { // Got Data from DB.
									res.send({
							  			'msg': {
							  				'data': doc,
							  				'files':"none" ,
							  				'stdout':"Nothing" ,
							  				'stderr':"Nothing"
							  			}
							  		});
								} else {
									res.send({
							  			'msg': {
							  				'data': null,
							  				'files': null ,
							  				'stdout': null ,
							  				'stderr': 'Error: Could not get any register from the DB.',
							  			}
							  		});
								}
								db.close();
							});
						});
					} else { // Data does not exist, upload the input file first.
						res.send({
				  			'msg': {
				  				'data': null,
				  				'files': null,
				  				'stdout': null,
				  				'stderr': 'Error: '+'Data does not exist, upload the input file first.',
				  			},
				  		});
						db.close();
					}
				}
			}
		);
	});
});


/* Configure the multer.*/
var done = false;
app.use(multer({
	dest: '../uploads/',
	// rename: function (fieldname, filename) {
	// 	return filename+Date.now();
	// },
	onFileUploadStart: function (file) {
		console.log(file.originalname + ' is starting ...');
	},
	onFileUploadComplete: function (file) {
		console.log(file.fieldname + ' uploaded to  ' + file.path);
		done = true;
	}
}));

// app.post('/api/photo',function(req,res) {
// 	if( done === true ) {
// 		console.log(req.files);
// 		res.end("File uploaded.");
// 		done = false;
// 	}
// });

app.post('/upload_new_network', function(req, res) {
	if( done === true ) {
		console.log(req.files);
		console.log("File uploaded.");
		res.end("File uploaded.");
		done = false;

		console.log("Loading results from DB");

		var url_parts = url.parse(req.url,true);

		var in_userID = Number(url_parts.query.userID);
		var in_sessionID = url_parts.query.sessionID;
		var in_src = url_parts.query.src; // values: 'src_default' || 'src_new_file'
		var in_inputfile = url_parts.query.inputfile; //  =Default

		var findDocument = function(db, obj, callback) {
			// Get the documents collection
			var collection = db.collection('test_coll');
			// Find the simulation results
			collection.findOne(obj, {},
				function(err, doc) {
					assert.equal(err, null);
					// assert.notEqual(doc, null); // We expect only 1 document.
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

			findDocument(db,
				{
					'id': 'initial_network',
					'userID': in_userID,
					'sessionID': in_sessionID,
					// 'src': in_src,
					'status': 'active',
				},
				function(doc) {
					if ( doc !== null ) { // Respond Data on the DB.
						res.send({
				  			'msg': {
				  				'data': doc,
				  				'files': null,
				  				'stdout': "Nothing",
				  				'stderr': "Nothing"
				  			}
				  		});
						db.close();
					}
				}
			);
		});
	}
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




