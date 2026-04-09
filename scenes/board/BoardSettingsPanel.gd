
extends Control

@export var socket : ResourceSocket :
	set(value):
		socket = value
		%board_tag_list.socket = value
		%profile_tag_list.socket = value

		socket.resource_changed.connect(_resource_changed)
		socket.resource_value_changed.connect(_resource_value_changed.unbind(1))

func _ready() -> void:
	%title.text_changed.connect(_title_changed)


func _resource_changed() -> void:
	# %title.text = socket.resource.name
	pass


func _resource_value_changed() -> void:
	if socket == null or socket.resource == null: return

	%title.text = socket.resource.name


func _title_changed(new_text: String) -> void:
	socket.resource.name = new_text
	socket.resource.save()


func _on_settings_toggled(toggled_on: bool) -> void:
	%settings.visible = toggled_on

	%title.editable = toggled_on
	%title.mouse_filter = Control.MOUSE_FILTER_STOP if toggled_on else Control.MOUSE_FILTER_IGNORE

	if not toggled_on:
		%title.release_focus()
