
extends Control


@export var affected_control : Control

@export_enum("Hide", "Queue Free") var action : int = 0


func _ready() -> void:
	if affected_control == null:
		affected_control = self


func _gui_input(event: InputEvent) -> void:
	if not is_visible_in_tree(): return

	if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		escape()


func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree(): return

	if event.is_action_released(&"loose_escape"):
		escape()
		get_viewport().set_input_as_handled()


func escape() -> void:
	match action:
		0:	affected_control.hide()
		1:	affected_control.queue_free()
