class_name SelectList extends BoxContainer

signal item_selected(item: SelectItem)
signal object_selected(object: Variant)

@export var selector_scene : PackedScene

@export var can_unselect : bool = false

var _selected_index : int = -1
var selected_index : int = -1 :
	get: return _selected_index
	set(value):
		if _selected_index == value: return

		if selected_item:
			if not can_unselect and _selected_index == -1:
				selected_item.set_pressed_no_signal(true)
				return
			selected_item._on_unselected()

		_selected_index = value

		if selected_item:
			selected_item._on_selected()

		item_selected.emit(selected_item)
		object_selected.emit(selected_object)

var selected_item : SelectItem :
	get: return get_child(selected_index) if selected_index != -1 else null
	set(value):
		if selected_item == value: return
		selected_index = value.index_in_list if value else -1

var selected_object : Variant :
	get: return selected_item.selection_object if selected_item else null
	set(value):
		if selected_object == value: return
		for child in get_children():
			if child.selection_object == value:
				selected_item = child
				return
		selected_index = -1

func _ready() -> void:
	refresh_list()
	ProfileList.global.modified.connect(refresh_list)

func refresh_list() -> void:
	for child in get_children(): child.queue_free()

	for profile in ProfileList.global_profiles:
		var node := selector_scene.instantiate()
		add_child(node)
		node.set.call_deferred(&"profile", profile)
