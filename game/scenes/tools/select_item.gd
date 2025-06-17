class_name SelectItem extends Button

signal selected
signal unselected

@onready var parent_list : SelectList = get_parent()
var index_in_list : int :
	get:
		for i in parent_list.get_child_count(): if parent_list.get_child(i) == self: return i
		return -1

func _toggled(toggled_on: bool) -> void:
	if toggled_on: 	select()
	else:			unselect()

var selection_object : Variant :
	get: return _get_selection_object()
func _get_selection_object() -> Variant: return null

func select() -> void:
	parent_list.selected_item = self
func _on_selected() -> void:
	set_pressed_no_signal(true)
	selected.emit()

func unselect() -> void:
	if parent_list.selected_item != self: return
	parent_list.selected_index = -1
func _on_unselected() -> void:
	set_pressed_no_signal(false)
	unselected.emit()
