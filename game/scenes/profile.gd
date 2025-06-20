class_name Profile extends JsonResource

#region Static

const ICONS : Array[Texture2D] = [
	preload("uid://dr2cpei5ronpv"),
]

const FOLDER_EXT := ".qrk"
const PATH := "profile.json"

const K_NAME := "name"
const K_ICON := "icon_uid"

static var RE_PROFILE_PATH : RegEx = RegEx.create_from_string(r".*\.qrk$")

#endregion

var _name : String
@export var name : String :
	get: return _name
	set(value):
		if _name == value: return
		_name = value
		commit_changes()
		Machine.global.commit_changes()

var _icon : Texture2D
@export var icon : Texture2D :
	get: return _icon
	set(value):
		if _icon == value: return
		_icon = value
		commit_changes()

var entries : Array[Note]


var name_from_save_dir : String :
	get:
		var start := save_dir.rfind("/") + 1
		var end := save_dir.rfind(Profile.FOLDER_EXT) - start
		return save_dir.substr(start, end)


func _init(__save_path__: String) -> void:
	super._init(__save_path__)
	if name.is_empty():	name = name_from_save_dir

	var note_paths := MincuzUtils.get_paths_in_folder( save_dir.path_join(Note.NOTES_SUBFOLDER_NAME), RegEx.create_from_string(r"\.json$"))
	print("Found %s entries in profile '%s'" % [ note_paths.size(), save_path ])
	for path in note_paths:
		var note := Note.new(path)
		entries.push_back(note)

	Machine.add_profile(self)


func _import_json(json: Dictionary) -> void:
	_name = json[K_NAME]
	_icon = load(json[K_ICON]) if ResourceLoader.exists(json[K_ICON]) else ICONS[0]


func _export_json(json: Dictionary) -> void:
	json.merge({
		K_NAME: name,
		K_ICON: JsonResource.get_resource_uid_path(icon),
	})


func make_active() -> void:
	Host.global.active_profile = self


func move(to_dir: String) -> void:
	if save_path == to_dir: return

	print("Moving profile '%s' to '%s'" % [ save_path, to_dir ])

	var err := DirAccess.rename_absolute(save_dir_slash, to_dir)
	if err != OK:
		ErrorOverlay.global_push("Error code (%s) while moving profile from '%s' to '%s'" % [ err, save_path, to_dir ])
		return

	save_path = to_dir.path_join(save_name)
	commit_changes()
	Machine.global.commit_changes()


func copy(to_dir: String) -> Profile:
	var result := hardcopy(to_dir)

	if result == null:
		return null

	# if FileAccess.file_exists(result.save_dir.path_join(Note.NOTES_SUBFOLDER_NAME)):
	var err := DirAccess.remove_absolute(result.save_dir.path_join(Note.NOTES_SUBFOLDER_NAME))
	if err != OK:
		ErrorOverlay.global_push("Error code (%s) while removing notes folder from copied profile '%s'" % [ err, result.save_path ])

	return result


func hardcopy(to_dir: String) -> Profile:
	if save_dir == to_dir:
		ErrorOverlay.global_push("Can't duplicate to the same path '%s'" % [ to_dir ])
		return null
	var err := DirAccess.copy_absolute(save_dir, to_dir)
	if err != OK:
		ErrorOverlay.global_push("Error code (%s) while copying profile from '%s' to '%s'" % [ err, save_dir, to_dir ])
		return null
	return Profile.new(to_dir.path_join(Profile.PATH))


func reveal() -> void:
	var err := OS.shell_show_in_file_manager(save_dir)
	if err != OK:
		ErrorOverlay.global_push("Error code (%s) while revealing profile '%s' in file manager." % [ err, save_path ])


func hide() -> void:
	Machine.remove_profile(self)
	Host.global.active_profile = null


func delete() -> void:
	hide()
	var err := DirAccess.remove_absolute(save_dir)
	if err != OK:
		ErrorOverlay.global_push("Error code (%s) while deleting profile '%s'" % [ err, save_path ])
