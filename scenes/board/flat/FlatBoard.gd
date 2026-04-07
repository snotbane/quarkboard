
class_name FlatBoard extends Board

@export_storage var sort : int


func _get_default_name() -> String:
	return "Flat"


func _get_default_icon() -> Texture2D:
	return preload("uid://lhx4bj3qqvba")

func _get_viewer_scene() -> PackedScene:
	return preload("uid://i4omm3hsucbn")
