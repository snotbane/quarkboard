
@tool class_name KeepFlowContainer extends HBoxContainer

signal items_changed

@export var size_target : Control

var _reverse_fill : bool = false
@export var reverse_fill : bool = false :
	get: return _reverse_fill
	set(value):
		if _reverse_fill == value: return
		_reverse_fill = value

var _vertical_alignment : VBoxContainer.AlignmentMode = VBoxContainer.ALIGNMENT_END
@export var vertical_alignment : VBoxContainer.AlignmentMode = VBoxContainer.ALIGNMENT_END :
	get: return _vertical_alignment
	set(value):
		_vertical_alignment = value
		for child in get_children():
			child.alignment = value


var _column_width : float = 200.0
@export var column_width : float = 200.0 :
	get: return _column_width
	set(value):
		value = maxf(value, 1.0)
		_column_width = value
		for child in get_children():
			child.custom_minimum_size.x = value
		_refresh_column_count.call_deferred()


var columns : int = 1 :
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
	get_child(0).custom_minimum_size.x = 200.0


func _ready() -> void:
	get_window().size_changed.connect(_refresh_column_count)

	# ## Please don't ask.
	# await get_tree().process_frame
	# await get_tree().process_frame
	# await get_tree().process_frame

	# _refresh_column_count.call_deferred()


func _refresh_column_count() -> void:
	columns = floori(size_target.size.x / column_width)


func add_grandchild(control: Control) -> void:
	get_smallest_column().add_child(control)


func get_grandchild_count() -> int:
	var result := 0
	for child in get_children():
		for grandchild in child.get_children():
			result += 1
	return result



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

	items_changed.emit()



func _sort_grandchildren(a: FlatQuarkViewer, b: FlatQuarkViewer) -> bool:
	return a.quark.time_modified > b.quark.time_modified


func get_smallest_column() -> VBoxContainer:
	var result : VBoxContainer = get_child(-1 if reverse_fill else 0)
	for i in get_child_count():
		var child : Control = get_child(-i-1 if reverse_fill else i)
		if child.is_queued_for_deletion(): continue
		if child.get_combined_minimum_size().y >= result.get_combined_minimum_size().y: continue
		result = child

	return result

