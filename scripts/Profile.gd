## Acts as a master folder and contains all notes.
class_name Profile extends JsonResource

const DIR_EXT := ".qrk"

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
			name = file_name
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


func move(to_dir: String) -> void:
	if file_dir == to_dir: return
	file_dir = to_dir

	print("Moving profile '%s' to '%s'" % [ file_path, to_dir ])

	# var err := DirAccess.rename_absolute(file_path_absolute.path_join(""), to_dir)
	# if err != OK:
	# 	printerr("Error code (%s) while moving profile from '%s' to '%s'" % [ err, file_path, to_dir ])
	# 	return

	# _file_path = to_dir.path_join(file_name)
	# save()
	Machine.inst.save()


## Copies settings only; not contents (notes).
func copy(to_dir: String) -> Profile:
	var result := copy_hard(to_dir)

	if result == null:
		return null

	# if FileAccess.file_exists(result.file_dir.path_join(Note.NOTES_SUBFOLDER_NAME)):
	var err := DirAccess.remove_absolute(result.file_dir.path_join(Quark.DIR_NAME))
	if err != OK:
		printerr("Error code (%s) while removing notes folder from copied profile '%s'" % [ err, result.file_path ])

	return result


## Copies settings and contents (notes).
func copy_hard(to_dir: String) -> Profile:
	if file_dir == to_dir:

		printerr("Can't duplicate to the same path '%s'" % [ to_dir ])
		return null
	var err := DirAccess.copy_absolute(file_dir, to_dir)
	if err != OK:
		printerr("Error code (%s) while copying profile from '%s' to '%s'" % [ err, file_dir, to_dir ])
		return null
	return Profile.new(to_dir.path_join(JsonResource.DATA_PATH))


func reveal() -> void:
	var err := OS.shell_show_in_file_manager(file_dir)
	if err != OK:
		printerr("Error code (%s) while revealing profile '%s' in file manager." % [ err, file_path ])


func hide() -> void:
	if Machine.profiles.has(self):
		Machine.profiles.erase(self)
		Machine.inst.save()
		Machine.inst.profile_removed.emit(self)
		Machine.active_profile = null


func delete() -> void:
	hide()

	var err := DirAccess.remove_absolute(file_dir)
	if err != OK:
		pass
