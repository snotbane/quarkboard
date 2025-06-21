class_name SelectItem extends Control

signal selected
signal unselected

@onready var parent_list : SelectList = get_parent()
@export var button : Button

var index_in_list : int :
	get:
		if not parent_list: return -1
		for i in parent_list.get_child_count(): if parent_list.get_child(i) == self: return i
		return -1

var selection_object : Variant :
	get: return _get_selection_object()
	set(value):
		if selection_object == value: return
		_set_selection_object(value)
func _get_selection_object() -> Variant: return null
func _set_selection_object(value: Variant) -> void: pass


func _toggled(toggled_on: bool) -> void:
	(select if toggled_on else unselect).call()


func select() -> void:
	parent_list.selected_item = self
func on_selected() -> void:
	button.set_pressed_no_signal(true)
	_on_selected()
	selected.emit()
func _on_selected() -> void: pass

func unselect() -> void:
	if parent_list.selected_item != self: return
	parent_list.selected_index = -1
func on_unselected() -> void:
	button.set_pressed_no_signal(false)
	_on_unselected()
	unselected.emit()
func _on_unselected() -> void: pass
