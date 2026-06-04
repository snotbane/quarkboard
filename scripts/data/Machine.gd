## Contains data for this machine only, e.g. locations of profiles, most recent profile selected.
class_name Machine extends JsonResource


static var inst: Machine


var profiles: Array[Profile]
var active_profile: Profile


func _init() -> void:
	inst = self

	super._init()


func _touched() -> void:
	print("active_profile : %s" % [active_profile])


func _serialize() -> Dictionary:
	var result := {}
	result.profiles = profiles.map(func(profile: Profile) -> String:
		return profile.file_path_absolute
	)
	result.active_profile = profiles.find(active_profile)
	return result

# func _deserialize(json: Variant, context: Object) -> Machine:
# 	profiles = json.get(&"profiles", []).map(func(path: String) -> Profile:
# 		return Profile.new_from_path(path)
# 	)
# 	if profiles.is_empty(): return
# 	active_profile = profiles[json.get(&"active_profile", 0)]
# 	print("profiles : %s" % [profiles])
# return self
