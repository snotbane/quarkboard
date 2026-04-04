
extends Button

# var _socket : ResourceSocket
@export var socket : ResourceSocket :
	get: return %list.socket
	set(value):
		# _socket = value
		# if not is_node_ready(): return

		%list.socket = value

func _ready() -> void:
	pass
