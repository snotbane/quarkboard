
class_name FlatQuarkViewer extends Control

static var REGEX_PATTERN_PREVIEW_STRIP_FRONT := RegEx.create_from_string(r"^\s*")
static var REGEX_PATTERN_PREVIEW_STRIP_BACK := RegEx.create_from_string(r"\s*$")



var quark : Quark :
	get: return socket.resource
	set(value):
		socket.resource = value

		# _on_resource_changed()


@onready var preview_label : PreviewLabel = %preview_label
@onready var socket : ResourceSocket = $resource_socket


func _ready() -> void:
	socket.resource_changed.connect(_on_resource_changed)
	socket.resource_value_changed.connect(_on_resource_value_changed.unbind(1))


func _on_resource_changed() -> void:
	preview_label.set_content(REGEX_PATTERN_PREVIEW_STRIP_FRONT.sub(socket.resource.text, ""))


func _on_resource_value_changed() -> void:
	if socket.resource:
		socket.resource.deleted.connect(queue_free)


func _on_pressed() -> void:
	quark.open_in_editor()


func _on_popout_pressed() -> void:
	quark.open_in_editor(true)
