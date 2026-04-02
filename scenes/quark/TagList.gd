
@tool extends Container

signal selected(tag: String)
signal removed(tag: String)

const TAG_READ_ONLY_SCENE := preload("uid://3cgv1vogw0y2")
const TAG_REMOVABLE_SCENE := preload("uid://0y4t03xeidt5")

@export var socket : ResourceSocket :
	set(value):
		if socket == value: return

		if socket:
			socket.resource_changed.disconnect(refresh)

		socket = value

		if socket:
			socket.resource_changed.connect(refresh)

		refresh()


@export_flags("Include Profile Tags:1", "Include Socket Tags:2", "Removable Profile Tags:4", "Removable Socket Tags:8") var options : int = 3

var _filter_lower : String
var filter : String :
	set(value):
		filter = value
		_filter_lower = filter.to_lower()
		if Engine.is_editor_hint(): return

		resort_children()


# func _ready() -> void:
# 	Machine.inst.active_profile_changed.connect(refresh)


func set_filter(value: String) -> void:
	filter = value


func add_tag_to_profile(tag: String, also_add_to_socket : bool = true) -> void:
	Machine.active_profile.tags.push_back(tag)
	Machine.active_profile.save()

	if also_add_to_socket:
		socket.resource.tags.push_back(tag)
		socket.resource.save()	## save() automatically calls refresh() here.
	else:
		refresh()



func refresh() -> void:
	# if not visible: return

	for child in get_children():
		child.queue_free()

	var available_tags : Dictionary[String, bool]

	if options & 1:
		for tag in Machine.active_profile.tags:
			available_tags[tag] = options & 4

	if socket and socket.resource:
		for tag : String in socket.resource.tags:
			if not options & 2:
				available_tags.erase(tag)
			else:
				available_tags[tag] = options & 8

	for tag in available_tags.keys():
		add_tag_control(tag, available_tags[tag])

	resort_children()


func add_tag_control(tag: String, removable: bool) -> Control:
	var scene : PackedScene = TAG_REMOVABLE_SCENE
	var result : Control = scene.instantiate()
	result.text = tag
	result.removable = removable

	result.selected.connect(selected.emit.bind(tag))
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

	return tag.find(_filter_lower)


func _filter_tag(tag: String) -> bool:
	return filter.is_empty() or tag.to_lower().contains(_filter_lower)