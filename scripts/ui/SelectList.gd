
class_name SelectList extends Container

signal item_selected(item: SelectItem)
signal object_selected(object: Variant)
signal selection_changed

@export var item_scene : PackedScene

@export var can_multi_select : bool = false
@export var can_unselect : bool = false

var _selected_children : Array[SelectItem]
var any_selected : bool :
	get: return not _selected_children.is_empty()


func add_item_to_selection(item:SelectItem) -> void:
	_add_item_to_selection(item)
	selection_changed.emit()
func _add_item_to_selection(item: SelectItem) -> void:
	if item in _selected_children: return

	_selected_children.push_back(item)
	item.on_selected()
	item_selected.emit(item)
	object_selected.emit(item.selection_object)


func add_series_to_selection_from_last(item: SelectItem) -> void:
	if not can_multi_select: return

	var idx_from : int = 0 if _selected_children.is_empty() else _selected_children.back().index_in_list
	var idx_to : int = item.index_in_list
	var increment := signi(idx_to - idx_from)

	while idx_from != idx_to:
		_add_item_to_selection(get_child(idx_from))
		idx_from += increment

	_add_item_to_selection(get_child(idx_to))
	selection_changed.emit()


func single_select(item: SelectItem) -> void:
	if item in _selected_children: return

	_remove_all_from_selection()
	_add_item_to_selection(item)

	selection_changed.emit()


func remove_all_from_selection() -> void:
	_remove_all_from_selection()

	selection_changed.emit()

func _remove_all_from_selection() -> void:
	for item in _selected_children.duplicate():
		_selected_children.erase(item)
		item.on_unselected()


func remove_item_from_selection(item: SelectItem) -> int:
	if _selected_children.size() == 1 and not can_unselect: return 1

	_selected_children.erase(item)
	item.on_unselected()

	selection_changed.emit()
	return OK



# var _selected_index : int = 0
# var selected_index : int = 0 :
# 	get: return _selected_index
# 	set(value):
# 		if _selected_index == value: return

# 		if selected_item:
# 			selected_item.unselect()

# 		_selected_index = value

# 		if selected_item:
# 			selected_item.select()

# 		item_selected.emit(selected_item)
# 		object_selected.emit(selected_object)
# func select_index(idx: int) -> void:
# 	selected_index = idx

# var selected_item : SelectItem :
# 	get: return get_child(selected_index) if selected_index != -1 else null
# 	set(value):
# 		if selected_item == value: return
# 		selected_index = value.index_in_list if value else -1
# func select_item(item: SelectItem) -> void:
# 	selected_item = item


# var selected_object : Variant :
# 	get: return selected_item.selection_object if selected_item else null
# 	set(value):
# 		if selected_object == value: return
# 		for child in get_children():
# 			if child.selection_object == value:
# 				selected_item = child
# 				return
# 		selected_index = -1
# func select_object(obj: Variant) -> void:
# 	selected_object = obj

# func _ready() -> void:
# 	refresh_list()

# func refresh_list() -> void:
# 	for child in get_children(): child.queue_free()
# 	_refresh_list.call_deferred()
# func _refresh_list() -> void: pass
