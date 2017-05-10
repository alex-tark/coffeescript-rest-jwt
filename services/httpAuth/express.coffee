express  	  = require 'express'
router	 	  = express.Router()

authorization = require './AuthController'
checkAuth	  = require '../CheckAuth'

router.post '/signup', (req, res, next) ->
	authorization.signUp req, res, next
	
router.post '/signin', (req, res, next) ->
	authorization.signIn req, res, next
	
router.post '/signout', checkAuth, (req, res, next) ->
	authorization.signOut req, res, next

module.exports = router