class_name MasonryBoard
extends Board


func _get_main_scene() -> PackedScene:
	return preload("res://scenes/board/MasonryBoardViewer.tscn")
