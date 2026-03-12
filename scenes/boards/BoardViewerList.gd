
class_name BoardViewerList extends SelectList

var active_profile : Profile

func _ready() -> void:
	Machine.inst.active_profile_changed.connect(_active_profile_changed)


func _active_profile_changed() -> void:
	for child in get_children():
		child.queue_free()

	if active_profile and active_profile.board_added.is_connected(_board_added):
		active_profile.board_added.disconnect(_board_added)

	active_profile = Machine.active_profile
	if active_profile == null: return

	active_profile.board_added.connect(_board_added)

	for board : Board in Machine.active_profile.boards:
		_board_added(board, false)


func _board_added(board: Board, make_active: bool = true) -> void:
	var item : SelectItemBoardViewer = item_scene.instantiate()
	item.board = board
	add_child(item)

