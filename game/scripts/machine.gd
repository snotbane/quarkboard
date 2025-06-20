class_name Machine extends JsonResource

const PATH := "user://machine_settings.json"
const K_PROFILE_LOCATIONS := "profile_locations"
const K_PROFILE_ACTIVE := "active_profile"

static var global : Machine = Machine.new(PATH)
static var global_profiles : Array

func _import_json(json: Dictionary) -> void:
	global_profiles = json.get(K_PROFILE_LOCATIONS, []).map(func(profile_path: String) -> Profile :
		var path := profile_path.path_join(Profile.PATH)

		if not FileAccess.file_exists(path):
			ErrorOverlay.global_push("Couldn't find profile at '%s'." % path)
			return null

		return Profile.new(profile_path.path_join(Profile.PATH))
	)

	for profile in global_profiles:
		if not profile: continue

		if profile.save_dir == json.get(K_PROFILE_ACTIVE, ""):
			Profile.active = profile
			break

func _export_json(json: Dictionary) -> void:
	json.merge({
		K_PROFILE_LOCATIONS: global_profiles.map(func(profile: Profile) -> String : return profile.save_dir),
		K_PROFILE_ACTIVE: Profile.active.save_dir if Profile.active else "",
	})

static func add_profile(profile: Profile) -> void:
	if Machine.global:
		_internal_add_profile(profile)
	else:
		_internal_add_profile.call_deferred(profile)
static func _internal_add_profile(profile: Profile) -> void:
	if global_profiles.has(profile): return
	global_profiles.push_back(profile)
	Machine.global.commit_changes()


static func remove_profile(profile: Profile) -> void:
	if not global_profiles.has(profile): return
	global_profiles.erase(profile)
	Machine.global.commit_changes()
