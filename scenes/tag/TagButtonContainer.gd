
class_name TagButtonContainer extends Container

const TAG_BUTTON_SCENE := preload("uid://dviqhihgm6ltf")


signal tag_toggled(toggled_on: bool, tag: String)
signal tag_pressed(tag: String)
signal tag_removed(tag: String)
signal filter_changed(new_filter: String)


## Tags in this resource will be available. If this resource's tags change, the list will be recreated.
@export var read_socket : ResourceSocket

@export_enum("None", "Active Profile") var read_fallback : int = 1

## Tags in this resource will be available and toggled. If this resource's tags change, the toggle state of children will be updated to reflect.
@export var write_socket : ResourceSocket

## Determines what to set [member write_socket] to if it is null.
@export_enum("None", "Read Socket", "Ancestor") var write_fallback : int = 1

@export_subgroup("Buttons", "button_")

@export_enum("Disabled", "Press Only", "Single Select", "Multi Meta", "Multi Select") var button_toggle_mode : int = 0

@export var button_feature_rename : bool = false

@export var button_feature_palette : bool = false

@export var button_feature_remove : bool = false

@export var button_confirm_remove : bool = false

@export var button_feature_display : bool = false



var _filter_lower : String
var filter : String :
	set(value):
		filter = value

		if _filter_lower == value.to_lower(): return
		_filter_lower = value.to_lower()

		filter_changed.emit(filter)
		refresh_buttons()


var read_write_sockets_are_different : bool :
	get: return read_socket != null and write_socket != null and read_socket != write_socket


func _ready() -> void:
	visibility_changed.connect(_visibility_changed)

	if read_socket == null:
		match read_fallback:
			1:
				read_socket = ResourceSocket.new()
				read_socket.resource = Machine.active_profile
				add_child(read_socket)

	read_socket.connect_resource_signal(&"tags_changed", recreate_buttons)

	if write_socket == null:
		match write_fallback:
			1: write_socket = read_socket
			2: write_socket = ResourceSocket.find_ancestor(self)

	if write_socket != read_socket:
		write_socket.connect_resource_signal(&"tags_changed", refresh_buttons)

	recreate_buttons()


func _visibility_changed() -> void:
	if _recreate_buttons_pending: 	recreate_buttons()
	if _refresh_buttons_pending:	refresh_buttons()


var _recreate_buttons_pending : bool = false
func recreate_buttons() -> void:
	var tagset = read_socket if read_socket else write_socket

	if not is_visible_in_tree() or tagset.resource == null: _recreate_buttons_pending = true; return
	_recreate_buttons_pending = false

	for child in get_children():
		if child is not Control: continue
		child.queue_free()

	var available_tags : TagSet = tagset.resource.tags

	for tag in available_tags:
		create_button(tag)

	refresh_buttons()


func create_button(tag: Tag) -> TagButton:
	var result : TagButton = TAG_BUTTON_SCENE.instantiate()

	result.tag = tag
	result.disabled = button_toggle_mode == 0
	result.toggle_mode = button_toggle_mode >= 2
	result.button_pressed = result.toggle_mode and read_write_sockets_are_different and write_socket.resource.tags.has(tag)
	result.feature_rename = button_feature_rename
	result.feature_palette = button_feature_palette
	result.feature_remove = button_feature_remove
	result.confirm_remove = button_confirm_remove
	result.feature_display = button_feature_display

	result.toggled.connect(_tag_toggled.bind(tag))
	result.pressed.connect(_tag_pressed.bind(tag))
	result.removed.connect(_tag_removed.bind(tag))

	add_child(result)
	return result


var _refresh_buttons_pending : bool = false
func refresh_buttons() -> void:
	if not is_visible_in_tree(): _refresh_buttons_pending = true; return
	_refresh_buttons_pending = false

	var cache := Myth.cache_children(self, "TagButton")
	cache.sort_custom(_sort_children)

	for button: TagButton in cache:
		button.visible = filter.is_empty() or button.text.to_lower().contains(_filter_lower)
		button.button_pressed = write_socket.resource.tags.has_tag_by_name(button.text) if button.toggle_mode and write_socket else false
		add_child(button)


func _sort_children(a: TagButton, b: TagButton) -> bool:
	if filter.is_empty():
		return a.text.to_lower() < b.text.to_lower()

	var a_score := _get_text_filter_score(a.text)
	var b_score := _get_text_filter_score(b.text)

	return (a.text.to_lower() < b.text.to_lower()) if (a_score == b_score) else (a_score < b_score)


func _get_text_filter_score(text: String) -> int:
	text = text.to_lower()

	if text == _filter_lower: return text.length() + 2
	if text.begins_with(_filter_lower): return text.length() + 1

	return text.find(_filter_lower)


func _tag_toggled(toggled_on: bool, tag: Tag) -> void:
	if read_write_sockets_are_different:
		if toggled_on:
			write_socket.resource.tags.push_back(tag)
		else:
			write_socket.resource.tags.erase(tag)

	tag_toggled.emit(toggled_on, tag)


func _tag_pressed(tag: Tag) -> void:
	tag_pressed.emit(tag)


func _tag_removed(tag: Tag) -> void:
	if write_socket == null: return

	write_socket.resource.tags.erase(tag)
	tag_removed.emit(tag)


func set_filter(value: String) -> void:
	filter = value


func toggle_or_create_tag_from_text(text: String) -> void:
	pass


func create_tag_from_text(text: String) -> void:
	var err : int = read_socket.resource.create_tag_by_name(text)
	if err: printerr(JsonResource.tag_error_string(err))
