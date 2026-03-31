
@tool extends Container

signal selected(tag: String)
signal removed(tag: String)

const TAG_READ_ONLY_SCENE := preload("uid://3cgv1vogw0y2")
const TAG_REMOVABLE_SCENE := preload("uid://0y4t03xeidt5")

@export var socket : ResourceSocket
@export var exclude_socket_tags : bool = false
@export var read_only := true

var _filter_lower : String
var filter : String :
	set(value):
		filter = value
		_filter_lower = filter.to_lower()
		if Engine.is_editor_hint(): return

		resort_children()


func set_filter(value: String) -> void:
	filter = value


func _ready() -> void:
	if socket == null:
		for tag in Machine.active_profile.tags:
			add_tag_control(tag)

		resort_children()
	else:
		socket.resource_changed.connect(refresh)


func refresh() -> void:
	if socket.resource == null:
		return

	if socket.resource.get(&"tags") != null:
		for child in get_children():
			child.queue_free()

		if exclude_socket_tags:
			for tag : String in Machine.active_profile.tags:
				if socket.resource.tags.has(tag): continue
				add_tag_control(tag)
		else:
			for tag : String in socket.resource.tags:
				add_tag_control(tag)

	resort_children()


func add_tag_control(tag: String) -> Control:
	var scene : PackedScene = TAG_READ_ONLY_SCENE if read_only else TAG_REMOVABLE_SCENE
	var result : Control = scene.instantiate()
	result.text = tag

	if result.has_signal(&"pressed"):
		result.pressed.connect(selected.emit.bind(tag))

	if result.has_signal(&"selected"):
		result.selected.connect(selected.emit.bind(tag))
	if result.has_signal(&"removed"):
		result.removed.connect(removed.emit.bind(tag))

	add_child(result)
	return result


func resort_children() -> void:
	var children : Array[Control]
	for child in get_children():
		children.push_back(child)
		remove_child(child)

	children.sort_custom(_sort_children)

	for child in children:
		add_child(child)
		child.visible = _filter_tag(child.text)


func _sort_children(a: Control, b: Control) -> bool:
	if filter.is_empty():
		return a.text < b.text

	var a_score := _score_filter(a.text)
	var b_score := _score_filter(b.text)

	return (a.text < b.text) if (a_score == b_score) else (a_score < b_score)


func _score_filter(tag: String) -> int:
	tag = tag.to_lower()

	if tag == _filter_lower: return tag.length() + 2
	if tag.begins_with(_filter_lower): return tag.length() + 1

	print("tag : %s" % [ tag ])
	print("_filter_lower : %s" % [ _filter_lower ])
	print("tag.find(_filter_lower) : %s" % [ tag.find(_filter_lower) ])

	return tag.find(_filter_lower)


func _filter_tag(tag: String) -> bool:
	return filter.is_empty() or tag.to_lower().contains(_filter_lower)