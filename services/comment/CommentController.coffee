mongoose = require 'mongoose'

require './models/comment'

class Project
	create: (req, res, next) ->
	    Resource = mongoose.model 'Comment'
	    fields   = req.body
	
	    proj     = new Resource(fields)
	    proj.save (err, resource) -> 
	        return res.send(403).json { status: false, message: err } if err?
	        res.json { status: true, data: resource, message: "Comment created" }
	
	findAll: (req, res, next) ->
		Resource = mongoose.model 'Comment'
		
		Resource.find({ user: req.body.user }).exec (err, coll) ->
			return res.send(403).json { status: false, message: err } if err?
			res.json { status: true, data: coll, message: "Comments list" }
			
	findById: (req, res, next) ->
		Resource = mongoose.model 'Comment'
		
		Resource.findById(req.params.id).exec (err, resource) ->
			return res.send(403).json { status: false, message: err } if err?
			if resource?
				if resource.user != req.body.user
					return res.status(401).json { status: false, message: "You don't have permission to see comment #" + req.params.id } 
				
				res.json { status: true, data: resource, message: "Comment element #" + req.params.id }
			
	update: (req, res, next) ->
	    Resource = mongoose.model 'Comment'
	    fields   = req.body
		
	    Resource.findByIdAndUpdate(req.params.id { $set: fiels }).exec (err, resource) ->
        	return res.send(403).json { status: false, message: err } if err?
        	res.json { status: true, data: resource, message: "Comment #" + req.params.id + " has been updated" } 
        	
	remove: (req, res, next) ->
	    Resource = mongoose.model 'Comment'
	
	    Resource.findByIdAndRemove(req.params.id).exec (err, resource) ->
        	return res.send(403).json { status: false, message: err } if err?
        	res.json { status: true, data: resource, message: "Comment #" + req.params.id + " has been removed" } 

module.exports = new Project()