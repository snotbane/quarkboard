
extends Control

const CREATE_VIEW_TYPES := {
	&"FlatBoard": "something"
}


func _ready() -> void:
	pass


func create_new_view(type: StringName) -> void:
	var board : Board

	match type:
		&"FlatBoard":
			board = FlatBoard.new()

	assert(board != null, "No board was created.")



	hide()
