## Contains save data for a single installation of the application. There is always only one and it should not be managed by the user.
class_name Machine extends JsonResource

const PATH := "user://machine.json"
const K_PROFILE_LOCATIONS := "profile_locations"
const K_PROFILE_ACTIVE := "active_profile"
const K_VIEW_ACTIVE := "active_view"

static var inst : Machine
static var profiles_locations : Dictionary


static var _active_profile : Profile
static var active_profile : Profile :
	get: return _active_profile if inst else null
	set(value):
		if _active_profile == value: return
		if value and not value.is_valid:
			push_error("Cannot set active profile to an invalid profile.")
			return

		_active_profile = value
		inst.active_profile_changed.emit()


static func _static_init() -> void:
	inst = Machine.new(PATH, false)
	inst.load()


signal profile_added(profile: Profile)
signal profile_removed(profile: Profile)
signal active_profile_changed


func profile_path_exists(path: String) -> bool:
	for profile : Profile in profiles_locations.keys():
		if profile.save_path == path:
			return profile.save_path_exists
	return false


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
			K_PROFILE_LOCATIONS: profiles_locations.keys()
				.filter( func(profile: Profile) -> bool:
					return profile != null
					)
				.map( func(profile: Profile) -> String:
					return profile.save_dir
					)
				,
			K_PROFILE_ACTIVE: maxi(0, profiles_locations.keys().find(active_profile)),
			K_VIEW_ACTIVE: 0,
		}


func json_import(json: Variant) -> void:
	for path : String in json.get(K_PROFILE_LOCATIONS, []):
		var profile := Profile.new(path.path_join(Profile.PATH))
		profiles_locations[profile] = path

	var idx : int = json.get(K_PROFILE_ACTIVE, 0)
	if idx > profiles_locations.size(): return

	profiles_locations.keys()[idx].make_active.call_deferred()

