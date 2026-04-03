
class_name TagButton extends Control

const MARGIN_READ_ONLY := 8
const MARGIN_REMOVABLE := 4

signal toggled(toggled_on: bool)
signal selected
signal removed

@export var text : String = "Tag" :
	get: return %label.text
	set(value): %label.text = value


## If enabled, the main button will be togglable
@export var toggle_mode : bool = true :
	set(value):
		toggle_mode = value
		if not is_node_ready(): return

		%select.toggle_mode = value
		_update_removable()


var _button_pressed : bool
@export var button_pressed : bool = false :
	get: return %select.button_pressed
	set(value):
		_button_pressed = value
		if not is_node_ready(): return

		%select.button_pressed = value


var removable : bool :
	get: return (toggle_mode and button_pressed) or use_remove_action
func _update_removable() -> void:
	%remove.visible = removable
	$margin_container.add_theme_constant_override(&"margin_right", MARGIN_REMOVABLE if removable else MARGIN_READ_ONLY)

## If enabled, the remove sub-button will be usable.
@export var use_remove_action : bool = false :
	get: return %remove.visible
	set(value):
		%remove.visible = value
		_update_removable()


var hovered : bool = false :
	set(value):
		hovered = value
		%remove.self_modulate = Color.WHITE if value else Color.TRANSPARENT


func _ready() -> void:
	%select.toggle_mode = toggle_mode
	%select.button_pressed = _button_pressed

	%select.toggled.connect(toggled.emit)
	%select.toggled.connect(_update_removable.unbind(1))
	%select.pressed.connect(selected.emit)
	%remove.pressed.connect(removed.emit)

	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

	_mouse_exited()


func _mouse_entered() -> void:
	hovered = true


func _mouse_exited() -> void:
	hovered = false
