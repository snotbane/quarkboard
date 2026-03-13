
class_name FlatBoard extends Board

@export_storage var sort : int

func _get_default_icon() -> Texture2D:
	return preload("uid://dn4aoui1gwbld")

func _get_viewer_scene() -> PackedScene:
	return preload("uid://i4omm3hsucbn")
