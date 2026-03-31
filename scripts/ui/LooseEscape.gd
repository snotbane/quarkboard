## Performs an action (e.g. hiding a node) when the user clicks outside this [Control].
extends Control

signal escaped

## If enabled, this will prevent lower controls from consuming input.
@export var consume_input : bool = true

@export_enum("On Press", "On Release") var trigger : int = 0


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree(): return

	if event.is_action_pressed(&"ui_cancel"):
		escaped.emit()
		get_viewport().set_input_as_handled()

	elif is_event_escape(event):
		escaped.emit()
		if consume_input:
			get_viewport().set_input_as_handled()


func is_event_escape(event: InputEvent) -> bool:
	return (
		event is InputEventMouseButton and
		(event.is_pressed() if trigger == 0 else event.is_released()) and
		(
			event.button_index == MOUSE_BUTTON_LEFT or
			event.button_index == MOUSE_BUTTON_RIGHT
		) and
		not get_global_rect().has_point(event.global_position)
	)

