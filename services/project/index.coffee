mongoose = require 'mongoose'
require './models/Project'

exports.create = (req, res) ->
    Resourse = mongoose.model 'Project'
    fields   = req.body

    proj     = new Resourse(fields)
    proj.save (err, resourse) -> 
        res.send err if err?
        res.json { status: true, data: resourse } if resourse?

exports.retrieve = (req, res) ->
	Resourse = mongoose.model 'Project'
	
	if req.params.id?
		Resourse.findById req.params.id, (err, resourse) ->
			res.send err if err?
			res.json { status: true, data: resourse } if resourse?
	else
		Resourse.find {}, (err, coll) ->
			res.json { status: true, data: coll } if coll?
			res.json err if err?

exports.update = (req, res) ->
    Resourse = mongoose.model('Project')
    fields   = req.body

    Resourse.findByIdAndUpdate req.params.id { $set: fiels }, (err, resourse) ->
        res.send(500, { status: false, error: err }) if err?
        res.send({ status: true, data: resourse }) if resourse?
        res.send(404)

exports.delete = (req, res) ->
    Resourse = mongoose.model('Project')

    Resourse.findByIdAndRemove req.params.id, (err, resourse) ->
        res.send(500, { status: false, error: err }) if err?
        res.send({ status: true, data: resourse }) if resourse?
        res.send(404)
        