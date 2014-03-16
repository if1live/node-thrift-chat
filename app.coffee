express = require 'express.io'
path = require 'path'
thrift = require 'thrift'
TBufferedTransport = require('thrift/lib/thrift/transport').TBufferedTransport
TJSONProtocol = require('thrift/lib/thrift/protocol').TJSONProtocol
ChatSvc = require './gen-nodejs/ChatSvc.js'
moment = require 'moment'

# thrift hello

class BaseHandler
  constructor: (req, res) ->
    @req = req
    @res = res

class ChatHandler extends BaseHandler
  say: (name, msg, result) ->
    now = moment().format('YY-MM-DD hh:mm:ss')
    line = "#{now} : [#{name}] #{msg}"
    console.log line
    @req.io.broadcast 'say', {line: line}
    result(null, true)

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

chatService = new ThriftService(ChatSvc, ChatHandler)
chatService.configure(app, '/chat')

app.listen app.get 'port'
console.log 'Express server listening on port ' + app.get 'port'
