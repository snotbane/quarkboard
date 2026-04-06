
class_name TagButton extends PanelContainer

signal toggled(toggled_on: bool)
signal pressed
signal tag_renamed(new_name: String)
signal removed

var _text : String
@export var text : String :
	get: return %label.text
	set(value):
		_text = value
		if not is_node_ready(): return

		%label.text = value
		%rename_edit.text = value


var _disabled : bool
@export var disabled : bool :
	get: return %main.disabled
	set(value):
		_disabled = value
		if not is_node_ready(): return

		%main.disabled = value
		%main.mouse_default_cursor_shape = CursorShape.CURSOR_ARROW if value else CursorShape.CURSOR_POINTING_HAND


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


var _feature_rename : bool
@export var feature_rename : bool :
	get: return %rename.visible
	set(value):
		_feature_rename = value
		if not is_node_ready(): return

		%rename.visible = value


var _feature_remove : bool
@export var feature_remove : bool :
	get: return %remove.visible
	set(value):
		_feature_remove = value
		if not is_node_ready(): return

		%remove.visible = value


@export var confirm_remove : bool = false


func _ready() -> void:
	text = _text

	disabled = _disabled
	toggle_mode = _toggle_mode
	button_pressed = _button_pressed
	%main.toggled.connect(toggled.emit)
	%main.pressed.connect(pressed.emit)

	feature_rename = _feature_rename

	feature_remove = _feature_remove

	%remove.pressed.connect(%remove_confirm.popup if confirm_remove else removed.emit)
	%remove_confirm.confirmed.connect(removed.emit)


func _on_tag_renamed(new_name: String) -> void:
	if not Machine.active_profile.can_add_tag(new_name):
		## Popup
		return

	Machine.active_profile.rename_tag_globally(text, new_name)
	tag_renamed.emit(new_name)
