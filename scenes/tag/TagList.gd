
class_name TagList extends Container

const TAG_BUTTON_SCENE := preload("uid://dviqhihgm6ltf")

signal tag_toggled(toggled_on: bool, tag: String)
signal tag_pressed(tag: String)
signal filter_changed(new_filter: String)

@export var source_socket : ResourceSocket

@export var socket : ResourceSocket :
	set(value):
		socket = value
		socket.resource_value_changed.connect(_resource_value_changed.unbind(1))

@export_enum("Socket Tags Only", "Profile + Toggle Socket Tags") var socket_mode : int = 0
@export_enum("Disabled", "Press Only", "Single Select", "Multi Select with meta", "Multi Select") var toggle_mode : int = 0
@export var feature_rename : bool = false
@export var feature_remove : bool = false
@export var confirm_remove : bool = false
@export var feature_display : bool = false

var _filter_lower : String
var filter : String :
	set(value):
		filter = value

		if _filter_lower == value.to_lower(): return
		_filter_lower = value.to_lower()

		filter_changed.emit(filter)
		reorder_buttons()
func set_filter(value: String) -> void:
	filter = value


func find_tag_button(tag: String) -> TagButton:
	for child in get_children():
		if child is not TagButton: continue
		if child.tag.name != tag: continue

		return child
	return null

var active_profile : Profile

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	Machine.inst.active_profile_changed.connect(_active_profile_changed)
	_active_profile_changed()


func _active_profile_changed() -> void:
	if active_profile:
		active_profile.tags.changed.disconnect(recreate_buttons)

	active_profile = Machine.active_profile

	if active_profile:
		active_profile.tags.changed.connect(recreate_buttons)



func _resource_value_changed() -> void:
	if socket.resource and socket.resource != Machine.active_profile:
		socket.resource.tags.changed.connect(reorder_buttons if socket_mode == 1 else recreate_buttons)

	recreate_buttons()


func _visibility_changed() -> void:
	if _recreate_buttons_queued:
		recreate_buttons()
	if _reorder_buttons_queued:
		reorder_buttons()


var _recreate_buttons_queued : bool = false
func recreate_buttons() -> void:
	if not is_visible_in_tree(): _recreate_buttons_queued = true; return
	_recreate_buttons_queued = false

	for child in get_children():
		if child is not Control: continue
		child.queue_free()

	var available_tags : TagSet
	match socket_mode:
		0 when socket.resource == null: return
		0: available_tags = socket.resource.tags if socket.resource.tags else null
		1: available_tags = Machine.active_profile.tags

	if available_tags == null: return

	for tag in available_tags.list:
		if socket_mode == 0 and Machine.active_profile.tags.has(tag): continue

		create_button(tag)

	reorder_buttons()


func create_button(tag: Tag) -> TagButton:
	var result : TagButton = TAG_BUTTON_SCENE.instantiate()
	result.tag = tag
	result.disabled = toggle_mode == 0
	result.toggle_mode = toggle_mode >= 2
	result.button_pressed = result.toggle_mode and socket_mode == 1 and socket and socket.resource.tags.has(tag)
	result.feature_rename = feature_rename
	result.feature_remove = feature_remove
	result.confirm_remove = confirm_remove
	result.feature_display = feature_display

	result.toggled.connect(_tag_toggled.bind(tag))
	result.pressed.connect(_tag_pressed.bind(tag))
	result.removed.connect(_tag_removed.bind(tag))

	add_child(result)
	return result


var _reorder_buttons_queued : bool = false
func reorder_buttons() -> void:
	if not is_visible_in_tree(): _recreate_buttons_queued = true; return
	_recreate_buttons_queued = false

	var children : Array[Control]
	for child in get_children():
		if child is not Control: continue
		children.push_back(child)
		remove_child(child)

	children.sort_custom(_sort_children)

	for child in children:
		child.visible = filter.is_empty() or child.text.to_lower().contains(_filter_lower)
		match socket_mode:
			1 when socket and child.toggle_mode:
				child.button_pressed = child.text in socket.resource.tags
		add_child(child)


func _sort_children(a: Control, b: Control) -> bool:
	if filter.is_empty():
		return a.text.to_lower() < b.text.to_lower()

	var a_score := _get_tag_filter_score(a.text)
	var b_score := _get_tag_filter_score(b.text)

	return (a.text.to_lower() < b.text.to_lower()) if (a_score == b_score) else (a_score < b_score)


func _get_tag_filter_score(tag: String) -> int:
	tag = tag.to_lower()

	if tag == _filter_lower: return tag.length() + 2
	if tag.begins_with(_filter_lower): return tag.length() + 1

	return tag.find(_filter_lower)


func add_existing_from_filter() -> void:
	if filter.is_empty(): return

	for tag in Machine.active_profile.tags:
		if _filter_lower != tag.to_lower(): continue

		var button := find_tag_button(filter)
		button.button_pressed = not button._button_pressed
		filter = ""

		break


func create_from_filter() -> void:
	var err := Machine.active_profile.tags.append_by_name(filter)
	if err != OK:
		printerr(TagSet.error_string(err))

	if socket.resource:
		socket.resource.tags.append_by_name(filter)

	var button := find_tag_button(filter)
	assert(button != null, "TagButton should be created for \"%s\"." % filter)

	button.button_pressed = not button._button_pressed
	filter = ""


func _tag_toggled(toggled_on: bool, tag: Tag) -> void:
	match socket_mode:
		1 when socket:
			if toggled_on == socket.resource.tags.has(tag): return
			if toggled_on:
				socket.resource.tags.append(tag)
			else:
				socket.resource.tags.erase(tag)

	tag_toggled.emit(toggled_on, tag)


func _tag_pressed(tag: Tag) -> void:
	tag_pressed.emit(tag)


func _tag_removed(tag: Tag) -> void:
	socket.resource.tags.erase(tag)

