
class_name FlatQuarkViewer extends Control

@onready var label : RichTextLabel = %label
@onready var socket : ResourceSocket = $resource_socket

var quark : Quark :
	get: return socket.resource
	set(value):
		socket.resource = value
		_on_resource_changed()

var max_height : float = 350.0

func _ready() -> void:
	socket.resource_changed.connect(_on_resource_changed)


func _on_resource_changed() -> void:
	print("label.size before setting text : %s" % [ label.size ])

	label.text = socket.resource.text

	if label.size.y > max_height:
		label.text = label.text.substr(0, label.text.length() * float(max_height / label.size.y)) + "..."

	print("label.size after  setting text : %s" % [ label.size ])


func _on_pressed() -> void:
	quark.open_in_editor()
