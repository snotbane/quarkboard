
class_name TagList extends Container

signal toggled(tag: String, toggled_on: bool)
signal selected(tag: String)
signal removed(tag: String)

const TAG_BUTTON_SCENE := preload("uid://0y4t03xeidt5")

@export var socket : ResourceSocket :
	set(value):
		if socket == value: return

		if socket:
			socket.resource_changed.disconnect(refresh)

		socket = value

		# if socket and not Engine.is_editor_hint():
		# 	socket.resource_changed.connect(refresh)

		refresh()


@export_flags("Include Profile Tags:1", "Include Socket Tags:2", "Removable Profile Tags:4", "Removable Socket Tags:8") var options : int = 3

## Single Select: Only one tag can be selected.
## Multi Meta: Multiple tags can be selected, but must be done while holding Shift or Ctrl.
## Multi Select: Multiple tags are selected using only the primary button; meta keys do nothing.
@export_enum("Single Select", "Multi Meta", "Multi Select") var multi_select : int = 0

@export var toggle_mode : bool = true

## If enabled, the socket resource's tags will be updated to match the state of each button.
@export var affect_socket : bool = true


var _filter_lower : String
var filter : String :
	set(value):
		filter = value
		_filter_lower = filter.to_lower()
		if Engine.is_editor_hint(): return

		resort_children()

var socket_tags_valid : bool :
	get: return socket and socket.resource and socket.resource.get(&"tags") != null

# func _ready() -> void:
# 	Machine.inst.active_profile_changed.connect(refresh)


func set_filter(value: String) -> void:
	filter = value


func text_submitted(text: String) -> void:
	var do_refresh := false
	var create_new := true

	var text_lower := text.to_lower()
	for tag in Machine.active_profile.tags:
		if text_lower == tag.to_lower():
			create_new = false
			text = tag
			break

	if create_new:
		if not await confirm_create_new_tag(text):
			return

		Machine.active_profile.tags.push_back(text)
		Machine.active_profile.save()
		do_refresh = true

	if socket and socket.resource and not socket.resource.tags.has(text):
		socket.resource.tags.push_back(text)
		socket.resource.save()
		do_refresh = false

	if do_refresh:
		refresh()


func refresh() -> void:
	if Engine.is_editor_hint(): return
	# if not visible: return

	for child in get_children():
		if child is not Control: continue
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
	var scene : PackedScene = TAG_BUTTON_SCENE
	var result : TagButton = scene.instantiate()
	result.text = tag
	result.toggle_mode = toggle_mode
	result.button_pressed = removable

	result.toggled.connect(_toggled.bind(tag))
	result.selected.connect(_toggled.bind(true, tag))
	result.removed.connect(_toggled.bind(false, tag))

	add_child(result)
	return result


func resort_children() -> void:
	var children : Array[Control]
	for child in get_children():
		if child is not Control: continue

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


func confirm_create_new_tag(tag: String) :
	var dialog := ConfirmationDialog.new()
	dialog.dialog_text = "You are creating a new tag \"%s\"." % [ tag ]
	dialog.ok_button_text = "Create"
	add_child(dialog)
	dialog.popup_centered()

	return await Async.any_indexed([ dialog.canceled, dialog.confirmed ]) == 1


func _toggled(toggled_on: bool, tag: String) -> void:
	toggled.emit(tag, toggled_on)
	if not (affect_socket and socket_tags_valid): return

	if toggled_on:
		if socket.resource.tags.has(tag): return
		print("added : %s" % [ tag ])
		socket.resource.tags.push_back(tag)
		socket.resource.save()
	else:
		if not socket.resource.tags.has(tag): return
		print("removed : %s" % [ tag ])
		socket.resource.tags.erase(tag)
		socket.resource.save()
