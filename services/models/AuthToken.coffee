mongoose = require 'mongoose'
Schema 	 = mongoose.Schema

AuthTokenSchema = new Schema {
	access_token: { type: String, required: true }
	client:	 	  { type: String, required: true }
	#client_id: 	  { type: String, required: true }
}

module.exports = mongoose.model 'AuthToken', AuthTokenSchema 