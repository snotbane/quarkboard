
extends Control

func _ready() -> void:
	pass


func _gui_input(event: InputEvent) -> void:
	if event.is_action_released(&"loose_escape"):
		hide()


func create_new_view(type: StringName) -> void:
	var board : Board

	var path := JsonResource.generate_save_path(Machine.active_profile.file_path_absolute.path_join(Board.DIR_NAME))

	match type:
		&"FlatBoard":
			board = FlatBoard.new(path)

	assert(board != null, "No board was created.")

	hide()
