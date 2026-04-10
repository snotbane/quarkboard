
class_name Tag extends Resource

const MAX_NAME_LENGTH := 50


@export_storage var name : String = "" :
	set(value):
		if name == value: return

		name = value
		emit_changed()


@export_storage var palette : int = UserPalette.SYSTEM :
	set(value):
		if palette == value: return

		palette = value
		emit_changed()


func _init(__name__: String = "", __palette__ : int = UserPalette.SYSTEM) -> void:
	name = __name__
	palette = __palette__


func _to_string() -> String:
	return name


func _serialize() -> Variant:
	return {
		&"name": name,
		&"palette": palette
	}

func _deserialize(json) -> bool:
	name = json[&"name"]
	palette = json[&"palette"]

	return true

