## Acts as a master folder and contains all notes.
class_name Profile extends JsonResource

const DIR_EXT := ".qbdp"

static var REGEX_PATTERN_PROFILE_PATH := RegEx.create_from_string(".*\\%s$" % DIR_EXT)

@export_storage var name : String
@export_storage var icon : Texture2D
@export_storage var tags : PackedStringArray

var quarks : Array
var boards : Array


func _init(__file_path_absolute__: String = "") -> void:
	super._init(__file_path_absolute__, true)

	if is_valid:
		if name.is_empty():
			name = file_name.capitalize()
			self.save()

		quarks.clear()
		for path in Myth.get_paths_in_folder(file_path_absolute.path_join(Quark.DIR_NAME)):
			quarks.push_back(Quark.new(path))

		boards.clear()
		for path in Myth.get_paths_in_folder(file_path_absolute.path_join(Board.DIR_NAME)):
			boards.push_back(Board.new(path))

		print("Found %s Quarks and %s Boards in profile '%s'" % [ quarks.size(), boards.size(), file_path_absolute ])

	_init_deferred.call_deferred()


func _init_deferred() -> void:
	assert(Machine.inst != null)

	if not Machine.profiles.has(self):
		Machine.profiles[self] = file_path_absolute
		Machine.inst.save()
		Machine.inst.profile_added.emit(self)


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

