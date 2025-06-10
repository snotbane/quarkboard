extends Node2D

@export var scroll_sensitivity := 1000.0

# var s

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var scroll_velocity := Vector2.ZERO
		match event.button_index:
			MOUSE_BUTTON_WHEEL_LEFT: 	scroll_velocity += Vector2.LEFT
			MOUSE_BUTTON_WHEEL_RIGHT: 	scroll_velocity += Vector2.RIGHT
			MOUSE_BUTTON_WHEEL_UP: 		scroll_velocity += Vector2.UP
			MOUSE_BUTTON_WHEEL_DOWN: 	scroll_velocity += Vector2.DOWN
		self.position += scroll_velocity * scroll_sensitivity
