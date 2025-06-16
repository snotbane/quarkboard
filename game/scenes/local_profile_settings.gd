extends Control

var _profile : LocalProfile
@export var profile : LocalProfile :
	get: return _profile
	set(value):
		if _profile == value: return

		if _profile:
			_profile.move_failed.disconnect(show_error)
			_profile.copy_failed.disconnect(show_error)

		_profile = value
		visible = _profile != null

		if _profile:
			_profile.move_failed.connect(show_error)
			_profile.copy_failed.connect(show_error)


@onready var error_dialog : AcceptDialog = $error_dialog


func _ready() -> void:
	visible = _profile != null


func show_error(message: String) -> void:
	error_dialog.dialog_text = message
	error_dialog.show()


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
