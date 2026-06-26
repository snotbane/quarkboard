extends Control

var board: Board:
	get: return $board.resource


func create_new_quark() -> void:
	board.create_new_quark()
