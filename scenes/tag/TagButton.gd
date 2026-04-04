
class_name TagButton extends PanelContainer

signal toggled(toggled_on: bool)
signal pressed

var _text : String
@export var text : String :
	get: return %label.text
	set(value):
		_text = value
		if not is_node_ready(): return

		%label.text = value


var _toggle_mode : bool
@export var toggle_mode : bool :
	get: return %main.toggle_mode
	set(value):
		_toggle_mode = value
		if not is_node_ready(): return

		%main.toggle_mode = value


var _button_pressed : bool
@export var button_pressed : bool :
	get: return %main.button_pressed
	set(value):
		_button_pressed = value
		if not is_node_ready(): return

		%main.button_pressed = value


func _ready() -> void:
	%label.text = _text
	%main.toggle_mode = _toggle_mode
	%main.button_pressed = _button_pressed

	%main.toggled.connect(toggled.emit)
	%main.pressed.connect(pressed.emit)
