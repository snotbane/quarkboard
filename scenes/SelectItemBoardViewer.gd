
class_name SelectItemBoardViewer extends SelectItem

var _board : Board
var board : Board :
	get: return _board
	set(value):
		if _board == value: return
		_board = value


func refresh() -> void:
	button.icon = board.icon if board else Board.ICON_UNKNOWN
	button.text = board.name
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER if button.text.is_empty() else HORIZONTAL_ALIGNMENT_LEFT
