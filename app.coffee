express = require 'express'
path = require 'path'
coffeeMiddleware = require 'coffee-middleware'

app = express()

app.set 'port', process.env.PORT || 3000
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'ejs'

# static file
app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
  res.render 'index', {}

app.listen app.get 'port'
console.log 'Express server listening on port ' + app.get 'port'
