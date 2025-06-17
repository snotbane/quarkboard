class_name Quarkboard extends Node

const ROOT_FOLDER_NAME := "quarkboard"

const CONFIG_PATH := "user://local_machine.cfg"

static var CONFIG := ConfigFile.new()

static var global_root_name : String :
	get: return ("." if Field.get_global(&"", &"local_data_hidden", false) else "") + ROOT_FOLDER_NAME

static var global_root : String :
	get: return Field.get_global(&"", &"local_data_path").path_join(global_root_name)

static var global_root_slash : String :
	get: return global_root.path_join("")


static func _static_init() -> void:
	if FileAccess.file_exists(CONFIG_PATH):
		var err := CONFIG.load(CONFIG_PATH)
		if err != OK: ErrorOverlay.global.push("Something went wrong while loading Quarkboard.CONFIG - Error code %s" % err)
	else:
		CONFIG.save(CONFIG_PATH)
