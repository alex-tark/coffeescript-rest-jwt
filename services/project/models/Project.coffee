mongoose = require 'mongoose'

Project = new mongoose.Schema(
  title: { type: String, required: true, default: "Project name" }
  description: { type: String, required: true, default: "Project description" }
  created_at: { type: Date, default: Date.now, required: false }
  user: { type: String, required: true, default: "admin" }
)

mongoose.model "Project", Project