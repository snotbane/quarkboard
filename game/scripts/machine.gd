class_name Machine extends JsonResource

const PATH := "user://machine_settings.json"
const K_PROFILE_LOCATIONS := "profile_locations"
const K_PROFILE_ACTIVE := "active_profile"
const K_VIEW_ACTIVE := "active_view"

static var global : Machine = Machine.new(PATH)
static var global_profiles : Array
static var initial_profile : Profile

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
			initial_profile = profile
			break

func _export_json(json: Dictionary) -> void:
	if not Host.global:
		## This occurs if the machine settings have been deleted, or on the very first run.
		json.merge({
			K_PROFILE_LOCATIONS: [],
			K_PROFILE_ACTIVE: null,
			K_VIEW_ACTIVE: 0,
		})
	else:
		json.merge({
			K_PROFILE_LOCATIONS: global_profiles
				.filter( func(profile: Profile) -> bool :
					return profile != null )
				.map( func(profile: Profile) -> String :
					return profile.save_dir)
				,
			K_PROFILE_ACTIVE: Host.global.active_profile.save_dir if Host.global.active_profile else "",
			K_VIEW_ACTIVE: 0,
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
