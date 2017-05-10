express = require 'express'
router  = express.Router()

project 	  = require './ProjectController'
access  	  = require './AccessProject'
checkAuth	  = require '../CheckAuth'
		
router.post  '/add', checkAuth, (req, res, next) -> 
	project.create req, res, next
	
router.post  '/update/:id', checkAuth, access, (req, res, next) ->
	project.update req, res, next
	
router.post  '/remove/:id', checkAuth, access, (req, res, next) -> 
	project.remove req, res, next
		
router.post  '/:id', checkAuth, access, (req, res, next) -> 
	project.findById req, res, next	
	
router.post  '/', checkAuth, (req, res, next) -> 
	project.findAll req, res, next

module.exports = router