class_name Quarkboard extends Node

const ROOT_FOLDER_NAME := "quarkboard"

static var global_root_name : String :
	get: return ("." if Field.get_global(&"", &"local_data_hidden", false) else "") + ROOT_FOLDER_NAME

static var global_root : String :
	get: return Field.get_global(&"", &"local_data_path").path_join(global_root_name)

static var global_root_slash : String :
	get: return global_root.path_join("")

