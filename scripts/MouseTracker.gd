
extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		RenderingServer.global_shader_parameter_set(&"mouse_position", event.global_position)
