
class_name BoardViewerList extends SelectList

var active_profile : Profile

func _ready() -> void:
	Machine.inst.active_profile_changed.connect(_active_profile_changed)
	_active_profile_changed()


func _boards_changed() -> void:
	for child in get_children():
		child.queue_free()

	if active_profile == null: return

	for board in active_profile.boards:
		_create_board_item(board)


func _active_profile_changed() -> void:
	if active_profile and active_profile.boards_changed.is_connected(_boards_changed):
		active_profile.boards_changed.disconnect(_boards_changed)

	active_profile = Machine.active_profile

	if active_profile:
		active_profile.boards_changed.connect(_boards_changed)

	_boards_changed()


func _create_board_item(board: Board) -> void:
	var item : SelectItemBoardViewer = item_scene.instantiate()
	item.board = board
	add_child(item)

