mongoose = require 'mongoose'
bcrypt   = require 'bcrypt'
jwt 	 = require 'jwt-simple'

require './models/AuthToken'
require './models/ClientAuth'
require './models/User'

class AuthToken
	
	signUp: (req, res, next) =>
		UserObserver = mongoose.model('User')
		AuthToken 	 = mongoose.model('AuthToken')
		
		fields = req.body
		# Поиск пользователя в базе
		UserObserver.findOne({ username: fields.username }).select('username').exec (err, user) ->
			return next err if err?
			if user?
				return res.json { status: false, message: fields.username + " already in use", field: "username" }
			else
				_user = new UserObserver(fields)
				
				_user.save (err, user) ->
					return res.json err if err?
					
					# Генерация JW токена по имени пользователя
					_token = jwt.encode {
								username: user.username
								}, 'secret-code'
					_date		 		= new Date()
					_date.setMonth(_date.getMonth() + 1)
					
					fields   			= {}
					fields.access_token = _token
					fields.expires 		= _date
					fields.user	   		= req.body.username
					
					TokenPresender 		= new AuthToken(fields)
					TokenPresender.save (err, resourse) -> 
						if err?
							return res.status(403).json { status: false, message: err } 
					    
						res.status(200).json { status: true, message: "You has been registered", token: _token }
		
	signIn: (req, res, next) ->
		UserObserver = mongoose.model('User')
		AuthToken 	 = mongoose.model('AuthToken')
		Client 		 = mongoose.model('ClientAuth')
		
		# Проверка на существование токента авторизации
		AuthToken.findOne({ user: req.body.username }).exec (err, _token) ->
			return res.status(403).json { status: false, message: err } if err?
			
			if not _token
				return res.status(401).json { message: "Not valid username", status: false, field: "username" }
			else
				# Поиск пользователя в базе
				UserObserver.findOne({ username: req.body.username }).exec (err, user) ->
					return next err if err?
					return res.status(401).json { message: "Not valid username", status: false, field: "username" } if not user
					
					bcrypt.compare req.body.password, user.password, (err, valid) ->
						return res.status(403).json { status: false, message: err } if err?
						
						return res.status(401).json { message: "Not valid password", status: false, field: "password" } if not valid
						
						# Поиск модели клиента в базе данных
						Client.findOne({ user: req.body.username }).exec (err, client) ->
							return next err if err?
							
							return res.status(200).json { client: client, status: true, message: "You has been authorized" } if client
							
							_client = { user: req.body.username, token: _token.access_token, cookie: { user_id: user._id, email: user.email, signin_at: user.signin_at } }
							
							ClientObserver = new Client(_client)
							ClientObserver.save (err, resource) ->
								return next(err) if err?
								res.status(200).json { client: _client, status: true, message: "You has been authorized" }
								
	signOut: (req, res, next) ->
		Client 		 = mongoose.model('ClientAuth')
		
		Client.findOneAndRemove({ token: req.headers['x-auth'], user: req.body.user }).exec (err) ->
			return res.status(403).json { status: false, message: err } if err?
			res.status(200).json { status: true, message: "You signed out" }


module.exports = new AuthToken()
