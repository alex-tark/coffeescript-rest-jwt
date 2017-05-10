mongoose = require 'mongoose'
bcrypt   = require 'bcrypt'
v4 		 = require('node-uuid').v4
jwt 	 = require 'jwt-simple'

# Mongoose models files
require '../../models/AuthToken'
require '../../models/ClientAuth'
require '../../models/User'

class AuthorizationToken
	
	signUp: (req, res, next) =>
		UserObserver = mongoose.model('User')
		Client 		 = mongoose.model('ClientAuth')
		
		fields = req.body
		# Find user document in database
		UserObserver.findOne({ username: fields.username }).select('username').exec (err, user) ->
			return next err if err?
			if user?
				return res.json { status: false, field: "username", message: fields.username + " already in use" }
			else
				_user = new UserObserver(fields)
				
				_user.save (err, user) ->
					return res.json err if err?
					
					_client = new Client({ 
						username: 	   user.username
						client_secret: new Buffer(_user.username, 'base64')
					})
					
					_client.save (err, client) ->
						return res.status(403).json { status: false, message: err } if err?
						return res.status(200).json { status: true, message: "You has been registered" } 
		
	signIn: (req, res, next) ->
		UserObserver = mongoose.model('User')
		AuthToken 	 = mongoose.model('AuthToken')
		Client 		 = mongoose.model('ClientAuth')
		
		UserObserver.findOne({ username: req.body.username }).exec (err, user) ->
			return res.status(403).json { status: false, message: err } if err?
			return res.status(401).json { status: false, field: "username", message: "Not valid username" } if not user
			
			bcrypt.compare req.body.password, user.password, (err, valid) ->
				return res.status(403).json { status: false, message: err } if err?
				
				return res.status(401).json { status: false, field: "password", message: "Not valid password" } if not valid
				
				# Find user document in database
				Client.findOne({ username: user.username }).exec (err, client) ->
					return next err if err?
					
					if client
						# Generate JWT by client permissions and expires date
						_date		 		= new Date()
						_date.setMonth(_date.getMonth() + 1)
						
						_token = jwt.encode {
									permissions: client.permissions,
									expires: 	 _date
									}, client.client_secret

						fields = { client: client._id, access_token: _token }
						
						Token  = new AuthToken(fields)
						Token.save (err, result) ->
							return res.status(403).json { status: false, message: err } if err?
							return res.status(200).json { status: true, data: _token, message: "You has been authorized" }
					else
						return res.send(402).json { status: false, message: err } 
								
	signOut: (req, res, next) ->
		AuthToken = mongoose.model('AuthToken')
		
		AuthToken.findOneAndRemove({ access_token: req.headers['x-auth'] }).exec (err) ->
			return res.status(403).json { status: false, message: err } if err?
			res.status(200).json { status: true, message: "You signed out" }


module.exports = new AuthorizationToken()
