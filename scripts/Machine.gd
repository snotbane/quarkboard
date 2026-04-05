## Contains save data for a single installation of the application. There is always only one and it should not really be accessible to the user.
class_name Machine extends JsonResource

const PATH := "user://machine.json"
const K_PROFILES := "profiles"
const K_PROFILE_ACTIVE := "active_profile"
const K_VIEW_ACTIVE := "active_view"

static var inst : Machine
static var profiles : Dictionary


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
	inst = Machine.new()


signal profile_added(profile: Profile)
signal profile_removed(profile: Profile)
signal active_profile_changed


func _init() -> void:
	super._init()

	touch(Machine.PATH)


func _saving() -> void:
	data = {
		K_PROFILES: profiles.values(),
		K_PROFILE_ACTIVE: maxi(0, profiles.keys().find(active_profile)),
		K_VIEW_ACTIVE: ViewerContainer.inst.current_tab,
	}


func _loaded() -> void:
	print(data)

	for path : String in data.get(K_PROFILES, []):
		var profile := Profile.new()
		profile.touch(path)
		profiles[profile] = path

	var idx : int = data.get(K_PROFILE_ACTIVE, 0)

	if idx >= profiles.size(): return

	profiles.keys()[idx].make_active.call_deferred()

