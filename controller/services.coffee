express = require 'express'
router	= express.Router()

router.use '/user', require '../services/httpAuth/express'
router.use '/project', require '../services/project/express'
router.use '/comment', require '../services/comment/express'

router.get '/', (req, res) ->
	res.json { status: true, message: "Project manager API" }

module.exports = router