## Acts as a master folder and contains all notes.
class_name Profile extends JsonResource

const DIR_EXT := ".qbdp"
const ICON_DEFAULT = preload("uid://d1f31r2b2kbdd")
const ICON_NULL := preload("uid://tn6tigaqju6d")

static var REGEX_PATTERN_PROFILE_PATH := RegEx.create_from_string(".*\\%s$" % DIR_EXT)
static var REGISTRY : Dictionary

signal board_added(board: Board, make_active: bool)
signal quark_added(quark: Quark)

@export_storage var name : String
@export_storage var icon : Texture2D = ICON_DEFAULT
@export_storage var tags : PackedStringArray

var quarks : Array
var boards : Array

func _get_save_as_dir_default() -> bool: return true


func _touched() -> void:
	if not is_valid: return

	REGISTRY[file_path_absolute] = self

	if name.is_empty():
		name = file_name.capitalize()
		self.save()

	_touched_deferred.call_deferred()
func _touched_deferred() -> void:
	assert(Machine.inst != null)

	if not Machine.profiles.has(self):
		Machine.profiles[self] = file_path_absolute
		Machine.inst.save()
		Machine.inst.profile_added.emit(self)


func _loaded() -> void:
	if not is_valid: return

	quarks.clear()
	for path in Myth.get_paths_in_folder(file_path_absolute.path_join(Quark.DIR_NAME)):
		if path.get_extension().is_empty(): continue

		var quark := Quark.new()
		quark.load(path)

		quarks.push_back(quark)

	boards.clear()
	for path in Myth.get_paths_in_folder(file_path_absolute.path_join(Board.DIR_NAME)):
		if path.get_extension().is_empty(): continue

		var board := Board.new()
		board.load(path)

		boards.push_back(board)

	print("Found %s Quarks and %s Boards in profile '%s'" % [ quarks.size(), boards.size(), file_path_absolute ])


func make_active() -> void:
	Machine.active_profile = self


func hide() -> void:
	if Machine.profiles.has(self):
		Machine.profiles.erase(self)
		Machine.inst.save()
		Machine.inst.profile_removed.emit(self)
		Machine.active_profile = null


func delete() -> void:
	hide()

	super.delete()

