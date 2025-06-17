extends Control

var _profile : Profile
@export var profile : Profile :
	get: return _profile
	set(value):
		if _profile == value: return
		_profile = value
		visible = _profile != null


func _ready() -> void:
	visible = _profile != null


func _on_create_dialog_file_selected(path: String) -> void:
	if DirAccess.dir_exists_absolute(path): ErrorOverlay.global_push("Can't create new profile. A profile with the same name already exists."); return
	var err := DirAccess.make_dir_recursive_absolute(path)
	if err != OK: ErrorOverlay.global_push("Something went wrong? (code %s)" % err); return

	var profile_path := path.path_join(Profile.PATH)
	Profile.new(profile_path)


func _on_import_dialog_dir_selected(dir: String) -> void:
	pass # Replace with function body.


func _on_move_dialog_dir_selected(dir:String) -> void:
	pass # Replace with function body.


func _on_duplicate_dialog_dir_selected(dir:String) -> void:
	pass # Replace with function body.


func _on_reveal_button_pressed() -> void:
	OS.shell_show_in_file_manager(profile.path)


func _on_hide_dialog_confirmed() -> void:
	pass # Replace with function body.
