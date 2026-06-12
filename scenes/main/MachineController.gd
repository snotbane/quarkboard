extends ResourceComponent

var machine: Machine:
	get: return resource

func add_profile_at_path(path: String) -> void:
	for existing in machine.profiles:
		if existing.file_path_absolute == path:
			printerr("A profile already exists here.")
			return

	machine.add_profile_at_path(path)
