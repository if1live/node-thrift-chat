express = require 'express.io'
path = require 'path'
thrift = require 'thrift'
TBufferedTransport = require('thrift/lib/thrift/transport').TBufferedTransport
TJSONProtocol = require('thrift/lib/thrift/protocol').TJSONProtocol
HelloSvc = require './gen-nodejs/HelloSvc.js'
TimesTwoSvc = require './gen-nodejs/TimesTwo.js'
ChatSvc = require './gen-nodejs/ChatSvc.js'

# thrift hello

class BaseHandler
  constructor: (req, res) ->
    @req = req
    @res = res

class HelloHandler extends BaseHandler
  @call_counter = 0

  hello_func: (result) ->
    console.log("Client call: " + (++HelloHandler.call_counter));
    result(null, "Hello Apache Thrift for JavaScript " + HelloHandler.call_counter)

    @req.io.broadcast 'new visitor'

class TimesTwoHandler extends BaseHandler
	dbl: (val, result) ->
		console.log("Client call: " + val)
		result(null, val * 2)

# express.io
app = express().http().io()

app.set 'port', process.env.PORT || 3000
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()

# static file
app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
  res.sendfile __dirname + '/public/index.html'

app.get '/hello.html', (req, res) ->
  res.sendfile __dirname + '/public/hello.html'

class ThriftService
  constructor: (@serviceCls, @handlerClass) ->

  configure: (app, uri) ->
    app.post uri, (req, res) =>
      handler = new @handlerClass(req, res)

      req.on 'data', TBufferedTransport.receiver (transportWithData) =>
        input = new TJSONProtocol(transportWithData)
        output = new TJSONProtocol new TBufferedTransport undefined, (buf) ->
          res.writeHead 200
          res.end buf

        processor = new @serviceCls.Processor(handler)
        processor.process(input, output)

helloService = new ThriftService(HelloSvc, HelloHandler)
helloService.configure(app, '/hello')

dblService = new ThriftService(TimesTwoSvc, TimesTwoHandler)
dblService.configure(app, '/dbl')


app.io.route 'ready', (req) ->
  req.io.broadcast 'new visitor'

app.listen app.get 'port'
console.log 'Express server listening on port ' + app.get 'port'
