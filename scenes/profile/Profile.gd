class_name Profile
extends JsonResourceQB

const FILE_EXTENSION := "qbdp"

const ICON_DEFAULT := preload("res://icons/profile_icons/00_user_alt_1.svg")
const ICON_BROKEN := preload("res://icons/triangle_exclamation.svg")


@export_storage var name: String
var name_safe: String:
	get: return name if name else "New Profile"


@export_storage var icon: Texture2D
var icon_safe: Texture2D:
	get: return icon if icon else ICON_DEFAULT


var quarks: Array[Quark]
var boards: Array[Board]


## Returns true if this profile is the currently active one, according to [Machine].
var is_active: bool:
	get: return Machine.inst.profile_active == self
	set(value):
		if value:
			Machine.inst.profile_active = self
			emit_changed()
		elif is_active:
			Machine.inst.profile_active = null
			emit_changed()


func _get_save_as_dir_default() -> bool:
	return true


func _loaded() -> void:
	Myth.transfer_array(quarks, load_children(Quark.new(), Quark.DIR))
	Myth.transfer_array(boards, load_children(Board.new(), Board.DIR))


# func _ready() -> void:
	# create_welcome_boards()


func create_welcome_boards() -> void:
	var welcome_board_everything := MasonryBoard.new()
	welcome_board_everything.name = "Everything"
	welcome_board_everything.icon = preload("res://icons/dazzle/cube_alt_1.svg")
	welcome_board_everything.internal_mode = Node.INTERNAL_MODE_FRONT
	boards.push_back(welcome_board_everything)

	var welcome_board_archive := MasonryBoard.new()
	welcome_board_archive.name = "Archive"
	welcome_board_archive.icon = preload("res://icons/dazzle/floppy_disk_alt.svg")
	welcome_board_archive.internal_mode = Node.INTERNAL_MODE_BACK
	boards.push_back(welcome_board_archive)

	var welcome_board_recycle := MasonryBoard.new()
	welcome_board_recycle.name = "Recycle"
	welcome_board_recycle.icon = preload("res://icons/dazzle/trash_clock.svg")
	welcome_board_recycle.internal_mode = Node.INTERNAL_MODE_BACK
	boards.push_back(welcome_board_recycle)


func _tags_init() -> Variant:
	return TagSuite.new(false)


func make_active() -> void:
	Machine.inst.profile_active = self


func unlink() -> void:
	Machine.inst.remove_profile(self)


func create_new_board(selector_idx: int) -> Board:
	var result: Board
	match selector_idx:
		0: result = MasonryBoard.new()
		# 1: result = TreeBoard.new(self)
		# 2: ...etc...
	assert(result != null, "Unimplemented board index.")

	save_child(result, generate_save_path(Board.DIR))
	boards.push_back(result)
	emit_changed()

	return result


func create_new_quark() -> Quark:
	var result := Quark.new()

	save_child(result, generate_save_path(Quark.DIR))
	quarks.push_back(result)
	emit_changed()

	return result
