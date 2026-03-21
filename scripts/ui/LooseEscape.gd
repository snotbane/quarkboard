
extends Control


@export var affected_control : Control

@export_enum("Hide", "Queue Free") var action : int = 0


func _ready() -> void:
	if affected_control == null:
		affected_control = self


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(&"loose_escape"):
		match action:
			0:	affected_control.hide()
			1:	affected_control.queue_free()

		get_viewport().set_input_as_handled()
