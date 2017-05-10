mongoose = require 'mongoose'

require './models/Project'

class Project
	create: (req, res, next) ->
	    Resource = mongoose.model 'Project'
	    fields   = req.body
	
	    proj     = new Resource(fields)
	    proj.save (err, resource) -> 
	        return res.send(403).json { status: false, message: err } if err?
	        res.json { status: true, data: resource, message: "Project created" }
	
	findAll: (req, res, next) ->
		Resource = mongoose.model 'Project'
		
		Resource.find({ user: req.body.user }).exec (err, coll) ->
			return res.send(403).json { status: false, message: err } if err?
			res.json { status: true, data: coll, message: "Projects list" }
			
	findById: (req, res, next) ->
		Resource = mongoose.model 'Project'
		
		Resource.findById(req.params.id).exec (err, resource) ->
			return res.send(403).json { status: false, message: err } if err?
			if resource?
				if resource.user != req.body.user
					return res.status(401).json { status: false, message: "You don't have permission to see project #" + req.params.id } 
				
				res.json { status: true, data: resource, message: "Project element #" + req.params.id }
			
	update: (req, res, next) ->
	    Resource = mongoose.model 'Project'
	    fields   = req.body
		
	    Resource.findByIdAndUpdate(req.params.id { $set: fiels }).exec (err, resource) ->
        	return res.send(403).json { status: false, message: err } if err?
        	res.json { status: true, data: resource, message: "Project #" + req.params.id + " has been updated" } 
        	
	remove: (req, res, next) ->
	    Resource = mongoose.model 'Project'
	
	    Resource.findByIdAndRemove(req.params.id).exec (err, resource) ->
        	return res.send(403).json { status: false, message: err } if err?
        	res.json { status: true, data: resource, message: "Project #" + req.params.id + " has been removed" } 


module.exports = new Project()