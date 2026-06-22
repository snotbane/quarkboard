@abstract
class_name Quark
extends JsonResourceQB

const DIR := "quarks"

var main_scene: PackedScene:
	get: return _get_main_scene()

@abstract
func _get_main_scene() -> PackedScene

func _init(profile: Profile) -> void:
	super._init(profile, DIR.path_join(generate_save_name() + ".json"))
