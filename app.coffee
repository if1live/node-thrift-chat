express = require 'express.io'
path = require 'path'

app = express()
app.http().io()

app.set 'port', process.env.PORT || 3000


# static file
app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
  res.sendfile __dirname + '/index.html'

app.listen app.get 'port'
console.log 'Express server listening on port ' + app.get 'port'
