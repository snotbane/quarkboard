
@tool class_name KeepFlowContainer extends HBoxContainer


var _reverse_fill : bool = false
@export var reverse_fill : bool = false :
	get: return _reverse_fill
	set(value):
		if _reverse_fill == value: return
		_reverse_fill = value


@export var vertical_alignment : VBoxContainer.AlignmentMode = VBoxContainer.ALIGNMENT_END :
	get: return get_child(0).alignment
	set(value):
		for child in get_children():
			child.alignment = value


@export var columns : int = 1 :
	get: return get_child_count()
	set(value):
		value = maxi(value, 1)
		if columns == value: return

		_hold_grandchildren()

		var inc := value - columns
		while inc > 0:
			_create_column()
			inc -= 1
		while inc < 0:
			get_child(-1).queue_free()
			inc += 1

		_place_grandchildren()
var columns_nodes : Array[VBoxContainer] :
	get:
		var result : Array[VBoxContainer]
		for child in get_children():
			if child is VBoxContainer:
				result.push_back(child)
		return result

func _init() -> void:
	add_child(VBoxContainer.new())
	get_child(0).alignment = VBoxContainer.ALIGNMENT_END


func add_grandchild(control: Control) -> void:
	get_smallest_column().add_child(control)


func _create_column() -> VBoxContainer:
	var result := VBoxContainer.new()
	result.alignment = vertical_alignment
	add_child(result)
	return result

var grandchild_hold : Array[Node]
func _hold_grandchildren() -> void:
	for child in get_children():
		for grandchild in child.get_children():
			child.remove_child(grandchild)
			grandchild_hold.push_back(grandchild)


func _place_grandchildren() -> void:
	grandchild_hold.sort_custom(_sort_grandchildren)

	# for i in get_child_count():
	# 	get_child(i).visible = i > grandchild_hold.size()

	while not grandchild_hold.is_empty():
		get_smallest_column().add_child(grandchild_hold.pop_back())



func _sort_grandchildren(a, b) -> bool:
	## TODO: sort by last modified date
	return false


func get_smallest_column() -> VBoxContainer:
	var result : VBoxContainer = get_child(-1 if reverse_fill else 0)
	for i in get_child_count():
		var child : Control = get_child(-i-1 if reverse_fill else i)
		if child.get_combined_minimum_size().y >= result.get_combined_minimum_size().y: continue
		result = child

	return result

