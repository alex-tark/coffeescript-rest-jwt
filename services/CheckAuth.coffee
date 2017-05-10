mongoose = require 'mongoose'
jwt = require 'jwt-simple'

# Файлы моделей базы данных
require './httpAuth/models/AuthToken'
require './httpAuth/models/ClientAuth'

module.exports = (req, res, next) ->
	if req.headers['x-auth']?
		AuthToken 	 = mongoose.model 'AuthToken'
		Client		 = mongoose.model 'ClientAuth'
		
		_token = req.headers['x-auth']
		AuthToken.findOne({ access_token: _token })
							.select('expires')
							.select('user').exec (err, item) ->
								return res.send(500).json err if err?
								
								_now = new Date()
								if _now.getTime() >= item.expires.getTime()
									return res.send(201).json { status: false, message: "Token timeout" }
								else
									Client.findOne({ user: req.body.user }).exec (err, client) ->
										return res.send(500).json err if err?
										
										if client
											return res.status(401).json { status: false, message: "You are not authorized" } if client.user != item.user
											
											return next()
										else
											return res.status(401).json { status: false, message: "You are not authorized" }
	else
		return res.status(401).json { status: false, message: "You are not authorized" }
