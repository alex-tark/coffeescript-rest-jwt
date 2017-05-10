mongoose = require 'mongoose'
Schema 	 = mongoose.Schema

AuthClientSchema = new Schema {
	user:   { type: String, required: true }
	token:  { type: String, required: true }
	cookie: { type: Object, required: true, default: {} }
}

module.exports = mongoose.model 'ClientAuth', AuthClientSchema 