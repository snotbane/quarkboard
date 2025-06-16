class_name LocalProfile extends JsonResource

const EXT := ".qrk"

static var active : LocalProfile

signal move_passed(destination: String)
signal move_failed(message: String)

signal copy_passed(destination: String)
signal copy_failed(message: String)

@export_global_file(("*" + EXT)) var path: String

var name : String :
	get: return path.substr(path.rfind("/"))

var location : String :
	get: return path.substr(0, path.rfind("/"))

var location_slash : String :
	get: return location.path_join("")


func make_active() -> void:
	active = self


func move(to_dir: String) -> int:
	if path == to_dir: return OK
	var err := DirAccess.rename_absolute(location_slash, to_dir.path_join(""))
	if err == OK:
		path = to_dir.path_join(name)
		move_passed.emit(to_dir)
	else:
		move_failed.emit("Error code (%s) while moving profile from '%s' to '%s'" % [ err, path, to_dir ])
	return err


func copy(to_dir: String) -> int:
	if path == to_dir:
		copy_failed.emit("Can't duplicate to the same path '%s'" % [ to_dir ])
		return ERR_ALREADY_EXISTS
	var err := DirAccess.copy_absolute(location_slash, to_dir.path_join(""))
	if err != OK:
		copy_passed.emit(to_dir)
	else:
		copy_failed.emit("Unknown error (%s)." % err)
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
