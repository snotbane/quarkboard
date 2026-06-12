## Contains data for this machine only, e.g. locations of profiles, most recent profile selected.
class_name Machine extends JsonResource


static var inst: Machine


var profiles: Array[Profile]
var profile_idx: Profile


func _init() -> void:
	inst = self

	super._init()


func _serialize() -> Dictionary:
	var result := {}
	result.profiles = profiles.map(func(profile: Profile) -> String:
		return profile.file_path_absolute
	)
	result.profile_idx = profiles.find(profile_idx)
	return result


func _deserialize(json: Dictionary) -> void:
	profiles.resize(json.profiles.size())
	for i in profiles.size():
		profiles[i] = Profile.new()
		profiles[i].load(json.profiles[i])

	if profiles.is_empty(): return
	profile_idx = profiles[json.get(&"profile_idx", 0)]


func add_profile_at_path(path: String) -> Profile:
	for existing in profiles:
		if existing.file_path_absolute == path: return existing

	var result := Profile.new()
	result.touch(path)
	profiles.push_back(result)
	emit_changed()


	return result
