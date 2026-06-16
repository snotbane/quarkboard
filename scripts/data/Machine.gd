## Contains data for this machine only, e.g. locations of profiles, most recent profile selected.
class_name Machine extends JsonResource


static var inst: Machine


var profile_active: Profile:
	set(value):
		if profile_active == value: return

		profile_active = value
		emit_changed()

var profiles: Array[Profile]


func _init() -> void:
	inst = self

	super._init()


func _serialize() -> Dictionary:
	var result := {}
	result.profile_active = profile_active.file_path_absolute if profile_active else ""
	result.profiles = profiles.map(func(profile: Profile) -> String:
		return profile.file_path_absolute
	)
	return result


func _deserialize(json: Dictionary) -> void:
	profiles.resize(json.profiles.size())
	for i in profiles.size():
		profiles[i] = Profile.new()
		profiles[i].load(json.profiles[i])

	var profile_active_path: String = json.get(&"profile_active", "")

	profile_active = null

	for profile in profiles:
		if profile.file_path_absolute == profile_active_path:
			profile_active = profile
			break


func add_profile_at_path(path: String) -> Profile:
	for existing in profiles:
		if existing.file_path_absolute == path: return existing

	var result := Profile.new()
	result.touch(path)
	profiles.push_back(result)
	emit_changed()

	return result
