express  = require 'express'
router	 = express.Router()

comment 	  = require './CommentController'
access  	  = require './AccessComment'
checkAuth	  = require '../CheckAuth'
		
router.post  '/add', checkAuth, (req, res, next) -> 
	comment.create req, res, next
	
router.post  '/update/:id', checkAuth, access, (req, res, next) ->
	comment.update req, res, next
	
router.post  '/remove/:id', checkAuth, access, (req, res, next) -> 
	comment.remove req, res, next
		
router.post  '/:id', checkAuth, access, (req, res, next) -> 
	comment.findById req, res, next	
	
router.post  '/', checkAuth, (req, res, next) -> 
	comment.findAll req, res, next


module.exports = router