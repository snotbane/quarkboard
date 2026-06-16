extends ResourceComponent

var machine: Machine:
	get: return resource


## Creates a new profile in the user data folder.
func create_new_profile() -> Profile:
	var result: Profile = null
	while result == null:
		result = add_profile_at_path("user://%s.%s" % [str(randi()), Profile.FILE_EXTENSION])

	return result


func add_profile_at_path(path: String) -> Profile:
	for existing in machine.profiles:
		if existing.file_path_absolute == path:
			printerr("A profile already exists here.")
			return null

	return machine.add_profile_at_path(path)
