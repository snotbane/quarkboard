
extends Node

@onready var parent : Control = get_parent()


func create_new_view(type: StringName) -> void:
	var board : Board
	var path := JsonResource.generate_save_path(Machine.active_profile.file_path_absolute.path_join(Board.DIR_NAME))

	match type:
		&"FlatBoard":
			board = FlatBoard.new()

	assert(board != null, "No board was created.")

	board.touch(path)
	parent.hide()
