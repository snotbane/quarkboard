
class_name ViewerContainer extends TabContainer

const PROFILE_TAB := 0
const SETTINGS_TAB := -1

static var inst : ViewerContainer

static func show_profile() -> void:
	inst.current_tab = PROFILE_TAB

static func show_settings() -> void:
	inst.current_tab = SETTINGS_TAB

func _ready() -> void:
	inst = self

	await get_tree().process_frame

	current_tab = Machine.inst.data.get(Machine.K_VIEW_ACTIVE, PROFILE_TAB)

