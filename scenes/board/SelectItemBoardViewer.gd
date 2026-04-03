
class_name SelectItemBoardViewer extends SelectItem

var _board : Board
var board : Board :
	get: return _board
	set(value):
		if _board == value: return

		_board = value
		refresh.call_deferred()


var viewer : BoardView


func refresh() -> void:
	button.icon = board.icon if board else Board.ICON_UNKNOWN
	button.text = board.name if board else ""
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER if button.text.is_empty() else HORIZONTAL_ALIGNMENT_LEFT
	button.expand_icon = true

	if viewer:
		viewer.queue_free()

	viewer = _board._get_viewer_scene().instantiate()
	viewer.board = board
	ViewerContainer.inst.add_child(viewer)

	button.pressed.connect(viewer.show)
