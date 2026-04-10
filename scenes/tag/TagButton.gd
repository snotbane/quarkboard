
@tool class_name TagButton extends Control

signal toggled(toggled_on: bool)
signal pressed
signal tag_renamed(new_name: String)
signal removed

var tag : Tag :
	set(value):
		if tag == value: return

		if tag:
			tag.changed.disconnect(_on_tag_changed)

		tag = value

		if tag:
			tag.changed.connect(_on_tag_changed)
func _on_tag_changed() -> void:
	if not is_node_ready(): return

	text = tag.to_string() if tag else ""


var _text : String
@export var text : String :
	get: return %label.text
	set(value):
		_text = value
		if not is_node_ready(): return

		%label.text = value


var _disabled : bool
@export var disabled : bool :
	get: return %main.disabled
	set(value):
		_disabled = value
		if not is_node_ready(): return

		%main.disabled = value
		%main.focus_mode = FOCUS_NONE if disabled else FOCUS_ALL
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

var _feature_display : bool
@export var feature_display : bool :
	get: return %display.visible
	set(value):
		_feature_display = value
		if not is_node_ready(): return

		%display.visible = value


var editable : bool :
	get: return %label.editable
	set(value):
		%label.editable = value
		%label.mouse_filter = Control.MOUSE_FILTER_STOP if value else Control.MOUSE_FILTER_IGNORE

		%rename.visible = not value
		%rename.button_pressed = value

		if value:
			%label.focus_mode = FOCUS_ALL
			%label.grab_focus.call_deferred()
			%label.select_all.call_deferred()
		else:
			%label.release_focus()
			%label.focus_mode = FOCUS_NONE


@onready var container : Container = get_parent()


func _ready() -> void:
	if tag: _on_tag_changed()

	disabled = _disabled
	toggle_mode = _toggle_mode
	%main.set_pressed_no_signal(_button_pressed)
	%main.toggled.connect(_on_main_toggled)
	%main.pressed.connect(pressed.emit)

	%label.focus_exited.connect(_on_rename_reverted)
	%label.text_submitted.connect(_on_rename_submitted)
	editable = false

	feature_rename = _feature_rename
	%rename.toggled.connect(_on_rename_toggled)

	feature_remove = _feature_remove
	%remove.pressed.connect(%remove_confirm.popup if confirm_remove else removed.emit)
	%remove_confirm.confirmed.connect(removed.emit)

	feature_display = _feature_display


func _on_main_toggled(toggled_on: bool) -> void:
	%display.button_pressed = toggled_on
	toggled.emit(toggled_on)


func _on_rename_toggled(toggled_on: bool) -> void:
	editable = toggled_on


func _on_rename_reverted() -> void:
	print("Reverted")
	editable = false
	text = _text


func _on_rename_submitted(new_name: String) -> void:
	new_name = JsonResource.format_string_for_tag(new_name)

	if _text != new_name and container and container.write_socket.resource.tags.has(new_name):
		printerr("Tag '%s' already exists in TagSet '%s'." % [ new_name, container.write_socket.resource.tags ])
		editable = true
		return

	editable = false

	if tag == null: return

	tag.name = new_name
	tag_renamed.emit(new_name)
