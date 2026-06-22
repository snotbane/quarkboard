@abstract
class_name Board
extends JsonResourceQB

const DIR := "boards"

# static func load_boards_in_profile(profile: Profile) -> void:


var main_scene: PackedScene:
	get: return _get_main_scene()

@export var name: String = "New Board"

@export var icon: Texture2D

@export_storage var internal_mode := Node.INTERNAL_MODE_DISABLED

@abstract
func _get_main_scene() -> PackedScene

func _init(profile: Profile = null) -> void:
	super._init(profile, DIR.path_join(generate_save_name() + ".json"))


## Creates a new [Quark], applying filters such that it is ensured to appear inside of this [Board].
func create_new_quark() -> void:
	pass
