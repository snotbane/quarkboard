
class_name IconToggleButton extends Button

@export var icon_pressed : Texture2D
@onready var icon_released : Texture2D = icon

func _ready() -> void:
	toggle_mode = true

	icon = icon_pressed if button_pressed else icon_released


func _toggled(toggled_on: bool) -> void:
	icon = icon_pressed if button_pressed else icon_released
