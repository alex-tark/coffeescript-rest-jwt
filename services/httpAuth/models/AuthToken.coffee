mongoose = require 'mongoose'
Schema 	 = mongoose.Schema

AuthTokenSchema = new Schema {
	access_token: { type: String, required: true }
	expires: { type: Date, default: Date.now, required: true }
	user:  { type: String, required: true }
}

module.exports = mongoose.model 'AuthToken', AuthTokenSchema 