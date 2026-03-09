
class_name SelectItem extends Control

signal selected
signal unselected


var index_in_list : int :
	get:
		if not parent_list: return -1

		for i in parent_list.get_child_count():
			if parent_list.get_child(i) == self:
				return i
		return -1

var selection_object : Variant :
	get: return _get_selection_object()
	set(value):
		if selection_object == value: return
		_set_selection_object(value)
func _get_selection_object() -> Variant: return null
func _set_selection_object(value: Variant) -> void: pass


@onready var parent_list : SelectList = get_parent()
@onready var button : Button = Myth.find_child_of_type(self, "Button")


func _ready() -> void:
	button.toggled.connect(_toggled)


func select_single() -> void:
	parent_list.single_select(self)
func select_series() -> void:
	parent_list.add_series_to_selection(self)
func select() -> void:
	parent_list.add_item_to_selection(self)
func on_selected() -> void:
	button.set_pressed_no_signal(true)
	_on_selected()
	selected.emit()
func _on_selected() -> void: pass


func unselect() -> void:
	var err := parent_list.remove_item_from_selection(self)
	if err != OK:
		button.set_pressed_no_signal(true)
func on_unselected() -> void:
	button.set_pressed_no_signal(false)
	_on_unselected()
	unselected.emit()
func _on_unselected() -> void: pass


func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		select_single()
	else:
		unselect()
