class_name Profile extends JsonResource

#region Static

const ICONS : Array[Texture2D] = [
	preload("uid://dr2cpei5ronpv"),
]

const FOLDER_EXT := ".qrk"
const PATH := "profile.json"
const K_ICON := "icon_uid"

static var active : Profile

#endregion

# signal move_passed(destination: String)
# signal move_failed(message: String)

# signal copy_passed(destination: String)
# signal copy_failed(message: String)

# var _path : String
# @export_global_file(("*" + FOLDER_EXT)) var path : String :
# 	get: return _path
# 	set(value):
# 		if _path == value: return
# 		_path = value
# 		commit_changes()

var _icon : Texture2D
@export var icon : Texture2D :
	get: return _icon
	set(value):
		if _icon == value: return
		_icon = value
		commit_changes()


var display_name : String :
	get:
		var start := save_dir.rfind("/") + 1
		var end := save_dir.rfind(Profile.FOLDER_EXT) - start
		return save_dir.substr(start, end)
var display_dir_path : String :
	get: return save_dir.substr(0, save_dir.rfind("/"))


func _init(__save_path__: String) -> void:
	super._init(__save_path__)
	ProfileList.add_profile(self)


func _import_json(json: Dictionary) -> void:
	_icon = load(json[K_ICON])


func _export_json(json: Dictionary) -> void:
	json.merge({
		K_ICON: JsonResource.get_resource_uid_path(icon)
	})


func make_active() -> void:
	active = self


func move(to_dir: String) -> int:
	if save_path == to_dir: return OK
	var err := DirAccess.rename_absolute(save_dir_slash, to_dir.path_join(""))
	if err == OK:
		save_path = to_dir.path_join(save_name)
		# move_passed.emit(to_dir)
	else:
		ErrorOverlay.global_push("Error code (%s) while moving profile from '%s' to '%s'" % [ err, save_path, to_dir ])
		# move_failed.emit("Error code (%s) while moving profile from '%s' to '%s'" % [ err, save_path, to_dir ])

	return err


func copy(to_dir: String) -> int:
	if save_path == to_dir:
		# copy_failed.emit("Can't duplicate to the same path '%s'" % [ to_dir ])
		return ERR_ALREADY_EXISTS
	var err := DirAccess.copy_absolute(save_dir_slash, to_dir.path_join(""))
	if err != OK:
		pass
		# copy_passed.emit(to_dir)
	else:
		ErrorOverlay.global_push("Unknown error (%s)." % err)
		# copy_failed.emit("Unknown error (%s)." % err)
	return err


func reveal() -> int:
	var err := OS.shell_show_in_file_manager(save_dir)
	if err == OK:
		pass
	else:
		pass
	return err


func hide() -> void:
	pass
