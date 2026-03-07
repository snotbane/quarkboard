## Acts as a master folder and contains all notes.
class_name Profile extends JsonResource

const DIR_EXT := ".qrk"
const PATH := "profile.json"
const NOTES_SUBFOLDER_NAME := "notes"

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
			# self.load()

		var note_paths := Myth.get_paths_in_folder(
			save_dir.path_join(NOTES_SUBFOLDER_NAME),
			RegEx.create_from_string("\\%s$" % note_ext)
		)

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

func json_import(json: Variant) -> void:
	super.json_import(json)

	if icon == null:
		icon = ICONS[0]


func make_active() -> void:
	Host.active_profile = self

func move(to_dir: String) -> void:
	pass

func copy(to_dir: String) -> void:
	pass

func copy_hard(to_dir: String) -> void:
	pass

func reveal() -> void:
	pass

func hide() -> void:
	if Machine.inst.profiles.has(self):
		Machine.inst.profiles.erase(self)
		Machine.inst.save()

	Host.active_profile = null

func delete() -> void:
	hide()

	var err := DirAccess.remove_absolute(save_dir)
	if err != OK:
		pass
