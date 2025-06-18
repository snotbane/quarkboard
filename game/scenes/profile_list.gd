class_name ProfileList extends JsonResource

const PATH := "user://global_profiles.json"
const K_PROFILE_LOCATIONS := "profile_locations"

static var global : ProfileList = ProfileList.new(PATH)
static var global_profiles : Array

func _import_json(json: Dictionary) -> void:
	global_profiles = json[K_PROFILE_LOCATIONS].map(func(profile_path: String) -> Profile : return Profile.new(profile_path.path_join(Profile.PATH)))

func _export_json(json: Dictionary) -> void:
	json.merge({
		K_PROFILE_LOCATIONS: global_profiles.map(func(profile: Profile) -> String : return profile.save_dir)
	})

static func add_profile(profile: Profile) -> void:
	if ProfileList.global:
		_internal_add_profile(profile)
	else:
		_internal_add_profile.call_deferred(profile)
static func _internal_add_profile(profile: Profile) -> void:
	if global_profiles.has(profile): return
	global_profiles.push_back(profile)
	ProfileList.global.commit_changes()


static func remove_profile(profile: Profile) -> void:
	if not global_profiles.has(profile): return
	global_profiles.erase(profile)
	ProfileList.global.commit_changes()
