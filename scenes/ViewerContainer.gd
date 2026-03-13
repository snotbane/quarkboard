
class_name ViewerContainer extends TabContainer

const PROFILE_TAB := 0
const SETTINGS_TAB := -1

static var inst : ViewerContainer

# static func find_board_in_children(board: Board) -> Node:
# 	for child in inst.get_children():
# 		if child.get(&"board") == null: continue
# 		if child.board == board: return child
# 	return null

# static func show_board(board: Board) -> void:
# 	var viewer := find_board_in_children(board)
# 	assert(viewer != null)

# 	viewer.show()

static func show_profile() -> void:
	inst.current_tab = PROFILE_TAB

static func show_settings() -> void:
	inst.current_tab = SETTINGS_TAB

func _ready() -> void:
	inst = self

