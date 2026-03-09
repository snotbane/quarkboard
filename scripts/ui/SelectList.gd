
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


func get_item_from_obj(obj: Variant) -> SelectItem:
	for child : SelectItem in get_children():
		if obj == child.selection_object: return child
	return null


func add_item_to_selection(item: SelectItem) -> void:
	_add_item_to_selection(item)
	selection_changed.emit()
func _add_item_to_selection(item: SelectItem) -> void:
	if item == null or item in _selected_children: return

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
	_add_item_to_selection(item)
	_remove_all_from_selection(item)

	selection_changed.emit()



func remove_all_from_selection(except: SelectItem = null) -> void:
	_remove_all_from_selection(except)

	selection_changed.emit()

func _remove_all_from_selection(except: SelectItem = null) -> void:
	for item in _selected_children.duplicate():
		if item == except: continue

		_selected_children.erase(item)
		item.on_unselected()


func remove_item_from_selection(item: SelectItem) -> int:
	if _selected_children.size() == 1 and not can_unselect: return 1

	_selected_children.erase(item)
	item.on_unselected()

	selection_changed.emit()
	return OK
