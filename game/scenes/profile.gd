class_name Profile extends JsonResource

#region Static

const ICONS : Array[Texture2D] = [
	preload("uid://dr2cpei5ronpv"),
]

const EXT := ".qrk"
const K_ICON := "icon_uid"

static var active : Profile
static var REGISTRY : Array[Profile]

static func _static_init() -> void:
	pass

#endregion

# signal move_passed(destination: String)
# signal move_failed(message: String)

# signal copy_passed(destination: String)
# signal copy_failed(message: String)

var _path : String
@export_global_file(("*" + EXT)) var path : String :
	get: return _path
	set(value):
		if _path == value: return
		_path = value
		commit_changes()

var _icon : Texture2D
@export var icon : Texture2D :
	get: return _icon
	set(value):
		if _icon == value: return
		_icon = value
		commit_changes()

var name : String :
	get: return path.substr(path.rfind("/") + 1)

var location : String :
	get: return path.substr(0, path.rfind("/"))

var location_slash : String :
	get: return location.path_join("")


func _export_json(json: Dictionary) -> void:
	json.merge({
		K_ICON: JsonResource.get_resource_uid_path(icon)
	})


func _import_json(json: Dictionary) -> void:
	_icon = load(json[K_ICON])


func make_active() -> void:
	active = self


func move(to_dir: String) -> int:
	if path == to_dir: return OK
	var err := DirAccess.rename_absolute(location_slash, to_dir.path_join(""))
	if err == OK:
		path = to_dir.path_join(name)
		# move_passed.emit(to_dir)
	else:
		ErrorOverlay.global_push("Error code (%s) while moving profile from '%s' to '%s'" % [ err, path, to_dir ])
		# move_failed.emit("Error code (%s) while moving profile from '%s' to '%s'" % [ err, path, to_dir ])

	return err


func copy(to_dir: String) -> int:
	if path == to_dir:
		# copy_failed.emit("Can't duplicate to the same path '%s'" % [ to_dir ])
		return ERR_ALREADY_EXISTS
	var err := DirAccess.copy_absolute(location_slash, to_dir.path_join(""))
	if err != OK:
		pass
		# copy_passed.emit(to_dir)
	else:
		ErrorOverlay.global_push("Unknown error (%s)." % err)
		# copy_failed.emit("Unknown error (%s)." % err)
	return err


func reveal() -> int:
	var err := OS.shell_show_in_file_manager(location)
	if err == OK:
		pass
	else:
		pass
	return err


func hide() -> void:
	pass
