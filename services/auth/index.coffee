express  	  = require 'express'
router	 	  = express.Router()

authorization = require './controllers/AuthController'
checkAuth	  = require '../CheckAuth'

router.post '/signup', (req, res, next) ->
	authorization.signUp req, res, next
	
router.post '/signin', (req, res, next) ->
	authorization.signIn req, res, next
	
router.get '/signout', checkAuth, (req, res, next) ->
	authorization.signOut req, res, next
		
router.get '/', checkAuth, (req, res, next) ->
	res.json { status: true, data: req.headers['x-auth'], message: "Auth API controller" }

module.exports = router