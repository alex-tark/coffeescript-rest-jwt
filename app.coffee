# NPM модули
express      = require 'express'
mongoose	 = require 'mongoose'
path         = require 'path'
logger		 = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser   = require 'body-parser'

app = express()

# Конфигурация приложения
app.set "port", process.env.PORT or 3000
app.set 'storage-uri', 'mongodb://<user>:<password>@ds017852.mlab.com:17852/auc'

app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })
app.use cookieParser()

app.use (req, res, next) ->
	res.header "Access-Control-Allow-Origin", "*"
	res.header 'Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE'
	res.header "Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"
	res.header 'Access-Control-Allow-Credentials', true
	next()
	
# Подключение к базе данных
mongoose.connect app.get('storage-uri'), { db: { safe: true }}, (err) ->
  console.log "Mongoose - connection error: " + err if err?
  console.log "Mongoose - connection OK"

# Роуты приложения и сиды
app.use '/', require './services/index'

app.use (req, res, next) ->
	err = new Error 'Not Found'
	err.status = 404
	next(err)
	
if app.get('env') == 'development'
	app.use (err, req, res, next) ->
		res.status err.status || 500 
		res.render 'error', {
			message: err.message
			error: err
		}

app.use (err, req, res, next) ->
	res.status err.status || 500
	res.json { status: false, message: "Wrong request:(" }


module.exports = app