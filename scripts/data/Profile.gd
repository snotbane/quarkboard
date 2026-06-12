class_name Profile extends JsonResource

@export_storage var name: String
@export_storage var quarks: Array

func _get_save_as_dir_default() -> bool:
	return true
