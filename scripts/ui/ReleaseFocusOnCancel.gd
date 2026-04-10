
extends Node

@export var input_action : StringName = &"ui_cancel"

func _ready() -> void:
	get_parent().gui_input.connect(_parent_gui_input.bind(get_parent()))

func _parent_gui_input(event: InputEvent, node: Node) -> void:
	if event.is_action_pressed(input_action):
		node.release_focus()
