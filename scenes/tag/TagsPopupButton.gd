
extends Button

@export var socket : ResourceSocket :
	get: return %list.socket
	set(value): %list.socket = value
