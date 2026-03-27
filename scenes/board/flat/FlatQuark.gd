
class_name FlatQuarkViewer extends Control


var quark : Quark :
	get: return socket.resource
	set(value): socket.resource = value


@onready var preview_label : PreviewLabel = %preview_label
@onready var socket : ResourceSocket = $resource_socket


func _ready() -> void:
	socket.resource_changed.connect(_on_resource_changed)
	socket.resource_value_changed.connect(_on_resource_value_changed.unbind(1))


func _on_resource_changed() -> void:
	preview_label.set_content(socket.resource.text)


func _on_resource_value_changed() -> void:
	if socket.resource:
		socket.resource.deleted.connect(queue_free)
		_on_resource_changed()


func _on_pressed() -> void:
	quark.open_in_editor()


func _on_popout_pressed() -> void:
	quark.open_in_editor(true)
