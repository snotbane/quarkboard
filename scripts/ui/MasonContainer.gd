
@tool class_name MasonContainer extends BoxContainer

signal items_changed

@export var size_target : Control

var _reverse_fill : bool = false
@export var reverse_fill : bool = false :
	get: return _reverse_fill
	set(value):
		if _reverse_fill == value: return
		_reverse_fill = value

var _sub_alignment : BoxContainer.AlignmentMode = BoxContainer.ALIGNMENT_BEGIN
@export var sub_alignment : BoxContainer.AlignmentMode = BoxContainer.ALIGNMENT_BEGIN :
	get: return _sub_alignment
	set(value):
		_sub_alignment = value
		for child in get_children():
			child.alignment = value


var _beam_size_min : float = 200.0
@export var beam_size_min : float = 200.0 :
	get: return _beam_size_min
	set(value):
		value = maxf(value, 1.0)
		_beam_size_min = value
		for child in get_children():
			child.custom_minimum_size.x = value
		_refresh_beam_count.call_deferred()


var beams : int = 1 :
	get: return get_child_count()
	set(value):
		value = maxi(value, 1)
		if beams == value: return

		_hold_bricks()

		var inc := value - beams
		while inc > 0:
			_create_beam()
			inc -= 1
		while inc < 0:
			get_child(-1).queue_free()
			inc += 1

		_place_bricks()
var beam_nodes : Array[BoxContainer] :
	get:
		var result : Array[BoxContainer]
		for child in get_children():
			if child is BoxContainer:
				result.push_back(child)
		return result


func _init() -> void:
	add_child(BoxContainer.new())
	get_child(0).vertical = not self.vertical
	get_child(0).alignment = BoxContainer.ALIGNMENT_BEGIN
	get_child(0).custom_minimum_size.x = 200.0


func _ready() -> void:
	if Engine.is_editor_hint(): return

	get_window().size_changed.connect(_refresh_beam_count)
	visibility_changed.connect(_visibility_changed)

func _visibility_changed() -> void:
	await get_tree().process_frame
	_refresh_beam_count()


func _refresh_beam_count() -> void:
	beams = floori(size_target.size.x / beam_size_min)


func add_brick(control: Control) -> void:
	get_smallest_beam().add_child(control)


func get_brick_count() -> int:
	var result := 0
	for child in get_children():
		for grandchild in child.get_children():
			result += 1
	return result



func _create_beam() -> BoxContainer:
	var result := BoxContainer.new()
	result.vertical = not self.vertical
	result.alignment = sub_alignment
	add_child(result)
	return result


var brick_hold : Array[Node]
func _hold_bricks() -> void:
	for child in get_children():
		for grandchild in child.get_children():
			child.remove_child(grandchild)
			brick_hold.push_back(grandchild)


func _place_bricks() -> void:
	brick_hold.sort_custom(_sort_bricks)

	# for i in get_child_count():
	# 	get_child(i).visible = i > brick_hold.size()

	while not brick_hold.is_empty():
		get_smallest_beam().add_child(brick_hold.pop_back())

	items_changed.emit()



func _sort_bricks(a: FlatQuarkViewer, b: FlatQuarkViewer) -> bool:
	return a.quark.time_modified > b.quark.time_modified


func get_smallest_beam() -> BoxContainer:
	var result : BoxContainer = get_child(-1 if reverse_fill else 0)
	for i in get_child_count():
		var child : Control = get_child(-i-1 if reverse_fill else i)
		if child.is_queued_for_deletion(): continue
		if child.get_combined_minimum_size().y >= result.get_combined_minimum_size().y: continue
		result = child

	return result

