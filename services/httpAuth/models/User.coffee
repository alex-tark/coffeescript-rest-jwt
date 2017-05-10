mongoose = require 'mongoose'
bcrypt = require 'bcrypt-nodejs'

UserSchema = new mongoose.Schema(
  username: { type: String, required: true, default: "undefined", unique: true }
  password: { type: String, required: true, default: "password" }
  email: { type: String, required: true, default: "admin@Admin.com" }
  signin_at: { type: Date, default: Date.now }
)

UserSchema.pre 'save', (callback) ->
	user = this
	
	return callback(null, null) if not user.isModified 'password'
	
	bcrypt.genSalt 5, (err, salt) ->
		return callback(err, null) if err?
		user.salt = salt
		
		bcrypt.hash user.password, salt, null, (err, hash) ->
			return callback(err, null) if err? 
			user.password = hash if hash?
			callback(null, user) if hash?
	
	
UserSchema.methods.verifyPassword = (_password, callback) ->
	bcrypt.compare _password, this.password, (err, here) ->
		callback(err, null) if err?
		callback(null, here) if here?

module.exports = mongoose.model "User", UserSchema