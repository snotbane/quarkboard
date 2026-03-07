## Contains save data for a single installation of the application. There is always only one and it should not be managed by the user.
class_name Machine extends JsonResource

const PATH := "user://machine.json"
const K_PROFILE_LOCATIONS := "profile_locations"
const K_PROFILE_ACTIVE := "active_profile"
const K_VIEW_ACTIVE := "active_view"

static var inst : Machine
static var profiles : Array


static func _static_init() -> void:
	inst = Machine.new(PATH)
	inst.load()


func profile_path_exists(path: String) -> bool:
	for profile : Profile in profiles:
		if profile.save_path == path:
			return profile.save_file_exists
	return false


func json_import(json: Variant) -> void:
	profiles = json.get(K_PROFILE_LOCATIONS, []).map(func(profile_path: String) -> Profile:
		var path := profile_path.path_join(Profile.PATH)
		return Profile.new(path)
	)

	if profiles.is_empty():
		printerr("No profiles exist! Auto create one please!")
		return

	profiles[json.get(K_PROFILE_ACTIVE, 0)].make_active.call_deferred()


func json_export() -> Dictionary:
	var reset_required : bool = false

	if reset_required:
		return {
			K_PROFILE_LOCATIONS: [],
			K_PROFILE_ACTIVE: 0,
			K_VIEW_ACTIVE: 0,
		}
	else:
		return {
			K_PROFILE_LOCATIONS: profiles
				.filter( func(profile: Profile) -> bool:
					return profile != null
					)
				.map( func(profile: Profile) -> String:
					return profile.save_dir
					)
				,
			K_PROFILE_ACTIVE: maxi(0, profiles.find(Host.inst.active_profile)),
			K_VIEW_ACTIVE: 0,
		}


