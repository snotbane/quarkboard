
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
	palette = tag.palette


var _text : String
@export var text : String :
	get: return %label.text
	set(value):
		_text = value
		if not is_node_ready(): return

		%label.text = value

var _palette : int
@export var palette : int :
	get: return _palette
	set(value):
		_palette = value
		if not tag: return

		%main.self_modulate = UserPalette.get_palette(value).normal_color
		tag.palette = value


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

var _feature_palette : bool
@export var feature_palette : bool :
	get: return %palette.visible
	set(value):
		_feature_palette = value
		if not is_node_ready(): return

		%palette.visible = value


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

	if _feature_rename:
		feature_rename = true
		%rename.pressed.connect(_on_rename_pressed)
	else:
		%rename.queue_free()

	if _feature_palette:
		feature_palette = true
		%palette.pressed.connect(_on_palette_pressed)
		%palette_selector.option_hovered.connect(_on_palette_hovered)
		%palette_selector.option_selected.connect(_on_palette_selected)
	else:
		%palette.queue_free()
		%palette_margin_container.queue_free()

	if _feature_remove:
		feature_remove = true
		%remove.pressed.connect(%remove_confirm.popup if confirm_remove else removed.emit)
		%remove_confirm.confirmed.connect(removed.emit)
	else:
		%remove.queue_free()

	feature_display = _feature_display


func _on_main_toggled(toggled_on: bool) -> void:
	%display.button_pressed = toggled_on
	toggled.emit(toggled_on)


func _on_rename_pressed() -> void:
	editable = true


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


func _on_palette_pressed() -> void:
	%palette_margin_container.show()
	%palette_selector.show_with_palette(tag.palette)


func _on_palette_hovered(idx: int) -> void:
	create_tween().tween_property(%main, "self_modulate", UserPalette.get_palette(idx if idx >= 0 else tag.palette).normal_color, 0.125)


func _on_palette_selected(idx: int) -> void:
	_on_palette_hovered(idx)
	%palette_margin_container.hide()

	if idx == -1: return

	tag.palette = idx

