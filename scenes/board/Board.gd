class_name Board
extends JsonResourceQB

const DIR := "boards"

# static func load_boards_in_profile(profile: Profile) -> void:


var main_scene: PackedScene:
	get: return _get_main_scene()

@export var name: String = "New Board"

@export var icon: Texture2D

@export_storage var internal_mode := Node.INTERNAL_MODE_DISABLED

var quarks: Array[Quark]:
	get: return parent.quarks

func _get_main_scene() -> PackedScene: return null


## Creates a new [Quark], applying filters such that it is ensured to appear inside of this [Board].
func create_new_quark() -> Quark:
	var result: Quark = parent.create_new_quark()

	# result.tags = tags.duplicate()
	emit_changed()
	return result
