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
	pass # Replace with function body.


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
