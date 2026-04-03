
extends Control



@export var socket : ResourceSocket :
	set(value):
		socket = value
		%board_tag_list.socket = value
		%profile_tag_list.socket = value

		socket.resource_changed.connect(_resource_changed)
		socket.resource_value_changed.connect(_resource_value_changed.unbind(1))

func _ready() -> void:
	%title_edit.text_changed.connect(_title_changed)


func _resource_changed() -> void:
	%title_label.text = socket.resource.name


func _resource_value_changed() -> void:
	if socket == null or socket.resource == null: return

	%title_label.text = socket.resource.name
	%title_edit.text = socket.resource.name

func _title_changed(new_text: String) -> void:
	socket.resource.name = new_text
	socket.resource.save()
