
class_name FlatQuarkViewer extends Control

@onready var label : RichTextLabel = %label
@onready var socket : ResourceSocket = $resource_socket

var quark : Quark :
	get: return socket.resource
	set(value): socket.resource = value

var max_height : float = 500.0

func _on_resource_changed() -> void:
	print("label.size before setting text : %s" % [ label.size ])

	label.text = socket.resource.text

	while label.size.y > max_height:
		break

	print("label.size after  setting text : %s" % [ label.size ])