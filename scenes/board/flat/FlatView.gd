
extends BoardView

const FLAT_QUARK_SCENE = preload("uid://ik6dmd4algrl")


func _ready() -> void:
	# Machine.inst.
	pass
	# Machine.active_profile.quark_added.connect()


# func


func create_new_quark() -> void:
	var quark : Quark
	var path := JsonResource.generate_save_path(Machine.active_profile.file_path_absolute.path_join(Quark.DIR_NAME))

	quark = Quark.new()
	quark.touch(path)
	quark.open_in_editor()
