express = require 'express'
router	= express.Router()

router.use '/auth', require '../services/auth/index'
#router.use '/project', require '../services/project/index'
#router.use '/comment', require '../services/comment/index'

router.get '/', (req, res) ->
	res.json { status: true, message: "Project manager API" }

module.exports = router