app   = require '../app'
debug = require('debug')('node-oauth2-server-component:server')
http  = require 'http'

normalizePort = (val) ->
	port = parseInt val, 10

	if isNaN(port) 
		return val

	if port >= 0
		return port
	
	return false

port = normalizePort process.env.PORT || '3000'
app.set 'port', port

server = http.createServer app
server.listen port, () ->
	console.log 'Express server listening on %d', port
	
	
onListening = () ->
	addr = server.address()
	bind = typeof addr == 'string' ? 'pipe ' + addr : 'port ' + addr.port
	
	debug 'Listening on ' + bind
	  
onError 	= () ->
	
	bind = typeof port == 'string' ? 'Pipe ' + port : 'Port ' + port
	
	if error.code == 'EACCES'
		console.error bind + ' requires elevated privileges'
		process.exit 1
		return
	  
	if error.code == 'EADDRINUSE'
		console.error ind + ' is already in use'
		process.exit 1
		return
		
	throw error
	
server.on 'error', onError
server.on 'listening', onListening
