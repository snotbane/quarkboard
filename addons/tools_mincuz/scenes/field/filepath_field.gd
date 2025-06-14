@tool class_name FilepathField extends StringField

static func get_path_dir(path: String) -> String:
	if DirAccess.dir_exists_absolute(path): return path
	return path.substr(0, path.rfind("/"))


@export var file_mode : FileDialog.FileMode :
	get: return $file_dialog.file_mode if $file_dialog else FileDialog.FileMode.FILE_MODE_OPEN_ANY
	set(value):
		if not find_child("file_dialog"): return
		$file_dialog.file_mode = value

@export var access : FileDialog.Access :
	get: return $file_dialog.access if $file_dialog else FileDialog.Access.ACCESS_FILESYSTEM
	set(value):
		if not find_child("file_dialog"): return
		$file_dialog.access = value


func _get_validation() -> String:
	var super_result := super._get_validation()
	if not super_result.is_empty(): return super_result
	match file_mode:
		FileDialog.FILE_MODE_OPEN_DIR:
			if DirAccess.dir_exists_absolute(field_value): return String()
			return "Path must be a valid FOLDER."
		FileDialog.FILE_MODE_OPEN_FILE, FileDialog.FILE_MODE_SAVE_FILE:
			if FileAccess.file_exists(field_value): return String()
			return "Path must be a valid FILE."
		FileDialog.FILE_MODE_OPEN_ANY, FileDialog.FILE_MODE_OPEN_FILES:
			if FileAccess.file_exists(field_value): return String()
			if DirAccess.dir_exists_absolute(field_value): return String()
	return "File path is not a valid file or folder."
