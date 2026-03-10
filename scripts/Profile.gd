## Acts as a master folder and contains all notes.
class_name Profile extends JsonResource

const DIR_EXT := ".qrk"
const PATH := "profile.json"

const ICONS : Array[Texture2D] = [
	null
	# preload("uid://dr2cpei5ronpv"),
]

static var REGEX_PATTERN_PROFILE_PATH := RegEx.create_from_string(r".*\.qrk$")

@export_storage var name : String
@export_storage var icon : Texture2D


var name_from_save_dir : String :
	get:
		var start := save_dir.rfind("/") + 1
		var end := save_dir.rfind(Profile.DIR_EXT) - start
		return save_dir.substr(start, end)

var note_ext : String :
	get: return ".json"


func _init(__save_path__: String = generate_save_path()) -> void:
	super._init(__save_path__)

	if is_valid:
		self.load()

		if name.is_empty():
			name = name_from_save_dir
			self.save()

		var note_paths := Myth.get_paths_in_folder(
			save_dir.path_join(Quark.DIR_NAME),
			RegEx.create_from_string("\\%s$" % note_ext)
		)

		# assert(false)

		print("Found %s entries in profile '%s'" % [ note_paths.size(), save_path ])

		# for path in note_paths:
		# 	var note := Note.new()
		# 	entries.push_back(note)

	_init_deferred.call_deferred()


func _init_deferred() -> void:
	assert(Machine.inst != null)

	if not Machine.inst.profiles.has(self):
		Machine.inst.profiles.push_back(self)
		Machine.inst.save()
		Machine.inst.profile_added.emit(self)


func json_import(json: Variant) -> void:
	super.json_import(json)

	if icon == null:
		icon = ICONS[0]


func make_active() -> void:
	Machine.active_profile = self


func move(to_dir: String) -> void:
	if save_path == to_dir: return

	print("Moving profile '%s' to '%s'" % [ save_path, to_dir ])

	var err := DirAccess.rename_absolute(save_dir_with_slash, to_dir)
	if err != OK:
		printerr("Error code (%s) while moving profile from '%s' to '%s'" % [ err, save_path, to_dir ])
		return

	save_path = to_dir.path_join(save_name)
	save()
	Machine.inst.save()


## Copies settings only; not contents (notes).
func copy(to_dir: String) -> Profile:
	var result := copy_hard(to_dir)

	if result == null:
		return null

	# if FileAccess.file_exists(result.save_dir.path_join(Note.NOTES_SUBFOLDER_NAME)):
	var err := DirAccess.remove_absolute(result.save_dir.path_join(Quark.DIR_NAME))
	if err != OK:
		printerr("Error code (%s) while removing notes folder from copied profile '%s'" % [ err, result.save_path ])

	return result


## Copies settings and contents (notes).
func copy_hard(to_dir: String) -> Profile:
	if save_dir == to_dir:

		printerr("Can't duplicate to the same path '%s'" % [ to_dir ])
		return null
	var err := DirAccess.copy_absolute(save_dir, to_dir)
	if err != OK:
		printerr("Error code (%s) while copying profile from '%s' to '%s'" % [ err, save_dir, to_dir ])
		return null
	return Profile.new(to_dir.path_join(Profile.PATH))


func reveal() -> void:
	var err := OS.shell_show_in_file_manager(save_dir)
	if err != OK:
		printerr("Error code (%s) while revealing profile '%s' in file manager." % [ err, save_path ])


func hide() -> void:
	if Machine.inst.profiles.has(self):
		Machine.inst.profiles.erase(self)
		Machine.inst.save()
		Machine.inst.profile_removed.emit(self)
		Machine.active_profile = null


func delete() -> void:
	hide()

	var err := DirAccess.remove_absolute(save_dir)
	if err != OK:
		pass
