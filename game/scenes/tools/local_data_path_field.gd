@tool extends FilepathField

func _value_changed_valid(new_value: Variant, old_value: Variant) -> void:
	if new_value == old_value: return
	var err := DirAccess.rename_absolute(old_value.path_join(Quarkboard.global_root_name).path_join(""), new_value.path_join(Quarkboard.global_root_name).path_join(""))
	if err != OK: printerr("Error (%s) while moving local_data_path to: '%s'" % [err, new_value.path_join(Quarkboard.global_root_name).path_join("")])


func _ready() -> void:
	super._ready()

	DirAccess.make_dir_recursive_absolute(Quarkboard.global_root)

