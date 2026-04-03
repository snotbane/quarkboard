
class_name BoardView extends Control

var board : Board :
	get: return $resource_socket.resource
	set(value): $resource_socket.resource = value
