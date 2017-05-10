mongoose = require 'mongoose'

Comment = new mongoose.Schema(
  title: { type: String, required: true, default: "Comment title" }
  description: { type: String, required: true, default: "Comment description" }
  created_at: { type: Date, default: Date.now }
  user: { type: String, required: true, default: "admin" }
  project: { type: String, required: true, default: "test" }
)

mongoose.model "Comment", Comment