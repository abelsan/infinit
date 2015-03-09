# SSDN Web platform interface

This project act as a template to create new web interfaces for the SSDN Matlab models.

Sections:
* [Server Requirements](#server-requirements)
* [Client Requirements](#client-requirements)
* [Running the server](#running-the-server)

---

## Server Requirements
Following requirements are intended for the Linux platform, eventually this could grow to others like Windows.

#### Operative System
[Ubuntu 14.04 LTS][ubuntu14] is recommended, but even version 12.04 LTS would work fine.
64-bit version is expected.

#### Matlab
The minimum Matlab version required is undefined yet but version 2012+ should work.

###### Toolboxes
The Matlab toolboxes required by the Infinit Model are:
* Optimization Toolbox
* Global Optimization Toolbox

###### CPLEX toolkit
Install the [IBM ILOG CPLEX Optimization Studio][cplex]


#### Database
Install the officially supported MongoDB packages: [Install MongoDB on Ubuntu][install-mongodb-on-ubuntu],
or
the Ubuntu maintained (and older) packages:
```sh
sudo apt-get install -y mongodb
```

#### Node.js
Web app and web server.

Officially supported: [Guide to install Node.js][installing-node.js-via-package-manager],
or, Ubuntu maintained:
```sh
sudo apt-get install -y nodejs
```

To compile and install native add-ons from npm you may also need to install build tools:

```sh
sudo apt-get install -y build-essential
```

#### Node package manager
```sh
sudo apt-get install -y npm
```

#### Optional tools

###### Nodejs-legacy
Helps prevent a conflict with the Amateur Packet Radio "Node" Program.
```sh
sudo apt-get install -y nodejs-legacy
```

###### Nodemon
Simple monitor script for use during development of a node.js app. Use `nodemon` instead of `node` command.
```sh
sudo npm install nodemon -g
```


---

## Client Requirements

#### Modern web browser
*TODO: Determine the minimal working versions.*

* Chrome
* Firefox

----

## Running the server
After getting the code, open a _Terminal_ window, move to the `server` sub-directory and start the server:
```sh
# $ ls
# docs  INFINIT1.0  matlab  mongodb  public  Readme.md  server
cd server/
node server.js
# listening on port 8080
```

Now, you can open the web browser on the address [http://localhost:8080/](http://localhost:8080/)

----
### Contributors

* [Roberto Aceves][roberto]
* [Takuto Ishimatsu][tak]
* [Almaha Almalki][maha]
* [Salma Aldawood][salma]

[roberto]:<mailto:aceves@mit.edu>
[tak]:<mailto:takuto@mit.edu>
[maha]:<mailto:almaha@mit.edu>
[salma]:<mailto:s.aldawood@cces-kacst-mit.org>

----

### Change log

*  ** 0.0.0 ** - Initial version. - [Roberto][roberto]
*  ** 0.1.0 ** - Switch to ExtJS based interface. - [Roberto][roberto]



[ubuntu14]:http://releases.ubuntu.com/14.04/
[install-mongodb-on-ubuntu]:http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
[installing-node.js-via-package-manager]:https://github.com/joyent/node/wiki/installing-node.js-via-package-manager
[cplex]:http://www-03.ibm.com/software/products/en/ibmilogcpleoptistud

