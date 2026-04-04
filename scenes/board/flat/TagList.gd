
class_name TagList extends Container

const TAG_BUTTON_SCENE := preload("uid://dviqhihgm6ltf")

@export var socket : ResourceSocket

@export_enum("Socket Tags Only", "Profile + Toggle Socket Tags") var socket_mode : int = 0
@export_enum("Press Only", "Single Select", "Multi Select with meta", "Multi Select") var toggle_mode : int = 0

var _filter_lower : String
var filter : String :
	set(value):
		filter = value

		if _filter_lower == value.to_lower(): return
		_filter_lower = value.to_lower()

		reorder_buttons()

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	Machine.inst.active_profile_tags_changed.connect(recreate_buttons)

	socket.resource_value_changed.connect(_resource_value_changed.unbind(1))


func _resource_value_changed() -> void:
	if socket.resource:
		socket.resource.tags_changed.connect(reorder_buttons if socket_mode == 1 else recreate_buttons)

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

	var available_tags : PackedStringArray
	match socket_mode:
		0 when socket.resource == null: return

		0:
			available_tags = socket.resource.tags.duplicate()
			for tag in socket.resource.tags:
				if Machine.active_profile.tags.has(tag): continue
				available_tags.erase(tag)

		1: available_tags = Machine.active_profile.tags.duplicate()

	for tag in available_tags:
		if tag not in Machine.active_profile.tags: continue

		create_button(tag)

	reorder_buttons()


func create_button(tag: String) -> TagButton:
	var result : TagButton = TAG_BUTTON_SCENE.instantiate()
	result.text = tag
	result.toggle_mode = toggle_mode > 0
	result.button_pressed = result.toggle_mode and socket and socket.resource.tags.has(tag)

	result.toggled.connect(_tag_toggled.bind(tag))
	result.pressed.connect(_tag_pressed.bind(tag))

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
			1 when socket and toggle_mode > 0:
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


func _tag_toggled(toggled_on: bool, tag: String) -> void:
	match socket_mode:
		1 when socket:
			if toggled_on:
				socket.resource.tags.push_back(tag)
			else:
				socket.resource.tags.erase(tag)
			socket.resource.save()
			socket.resource.tags_changed.emit()


func _tag_pressed(tag: String) -> void:
	pass
