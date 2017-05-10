mongoose = require 'mongoose'

require './models/Project'

module.exports = (req, res, next) ->
	Resource = mongoose.model 'Project'
	
	Resource.findById(req.params.id).exec (err, project) ->
		return res.send(403).json { status: false, message: err } if err?
		
		if project?
			if project.user != req.body.user
				return res.status(401).json { status: false, message: "You don't have access to the project #" + req.params.id }
			return next()
		
		res.status(401).json { status: false, message: "You don't have access to the project #" + req.params.id }
				
