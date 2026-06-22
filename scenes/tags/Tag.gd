class_name Tag extends Resource

@export_storage var name: String
@export_storage var palette: int

func _init(__name__: String) -> void:
	name = __name__

func _to_string() -> String:
	return name
