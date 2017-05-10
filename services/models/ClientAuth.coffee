mongoose = require 'mongoose'
Schema 	 = mongoose.Schema

AuthClientSchema = new Schema {
	username: 	   { type: String, required: true, unique: true }
	permissions:   { type: Number, required: false, default: 0 } # 0 - simple user, 1 - moderator, 2 - admin, 3 - sudo
	client_secret: { type: String, required: true }
}

module.exports = mongoose.model 'ClientAuth', AuthClientSchema 