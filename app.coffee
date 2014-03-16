express = require 'express.io'
path = require 'path'
thrift = require 'thrift'
TBufferedTransport = require('thrift/lib/thrift/transport').TBufferedTransport
TJSONProtocol = require('thrift/lib/thrift/protocol').TJSONProtocol
HelloSvc = require './gen-nodejs/HelloSvc.js'
TimesTwoSvc = require './gen-nodejs/TimesTwo.js'

# thrift hello
helloHandler = {
	hello_func: (result) ->
		this.call_counter = this.call_counter || 0
		console.log("Client call: " + (++this.call_counter));
		result(null, "Hello Apache Thrift for JavaScript " + this.call_counter)
}

timesTwoHandler = {
	dbl: (val, result) ->
		console.log("Client call: " + val)
		result(null, val * 2)
}

helloService = {
	transport: TBufferedTransport,
	protocol: TJSONProtocol,
	cls: HelloSvc,
	handler: helloHandler
}

dblService = {
	transport: TBufferedTransport,
	protocol: TJSONProtocol,
	cls: TimesTwoSvc,
	handler: timesTwoHandler
}

StaticHttpThriftServerOptions = {
	staticFilePath: __dirname + "/public",
	services: {
		"/hello": helloService,
		"/dbl": dblService,
	}
}


server = thrift.createWebServer(StaticHttpThriftServerOptions);
port = 8585;
server.listen(port);
console.log("Http/Thrift Server running on port: " + port);

###
app = express().http().io()

app.set 'port', process.env.PORT || 3000

# static file
app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
  res.sendfile __dirname + '/public/index.html'

app.io.route 'ready', (req) ->
  req.io.broadcast 'new visitor'

app.listen app.get 'port'
console.log 'Express server listening on port ' + app.get 'port'
###
