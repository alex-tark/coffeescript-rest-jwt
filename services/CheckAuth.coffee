mongoose = require 'mongoose'
jwt 	 = require 'jwt-simple'

# Mongoose models files
require './models/AuthToken'
require './models/ClientAuth'

module.exports = (req, res, next) ->
	if req.headers['x-auth']?
		AuthToken 	 = mongoose.model 'AuthToken'
		Client		 = mongoose.model 'ClientAuth'
		
		_token = req.headers['x-auth']
		AuthToken.findOne({ access_token: _token }).exec (err, item) ->
								return res.status(401).json { status: false, message: "You are not authorized" } if err?
								return res.status(401).json { status: false, message: "You are not authorized" } if not item
								
								Client.findById(item.client).exec (err, client) ->
									return res.status(401).json { status: false, message: "You are not authorized" } if err?
									return res.status(401).json { status: false, message: "You are not authorized" } if not client 
									
									decoded_token = jwt.decode item.access_token, client.client_secret
									
									_now = new Date()
									_expires = new Date(decoded_token.expires)
									if _now.getTime() >= _expires.getTime()
										return res.send(201).json { status: false, message: "Token timeout" }
									else
										return next()
	else
		return res.status(401).json { status: false, message: "You are not authorized" }
