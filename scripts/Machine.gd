## Contains save data for a single installation of the application. There is always only one and it should not really be accessible to the user.
class_name Machine extends JsonResource

const PATH := "user://machine.json"
const K_PROFILES := "profiles"
const K_PROFILE_ACTIVE := "active_profile"
const K_VIEW_ACTIVE := "active_view"

static var inst: Machine
static var profiles: Dictionary


static var _active_profile: Profile
static var active_profile: Profile:
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


@export_storage var profile_paths: PackedStringArray:
	get: return profiles.values()
	set(value):
		for path in value:
			var profile := Profile.new()
			profile.touch(path)
			profiles[profile] = path


@export_storage var active_profile_idx: int:
	get: return maxi(0, profiles.keys().find(active_profile))
	set(value):
		if value < 0 or value >= profiles.size(): return
		profiles.keys()[value].make_active.call_deferred()


@export_storage var active_view: int:
	get: return ViewerContainer.inst.current_tab if ViewerContainer.inst else 0
	set(value):
		if ViewerContainer.inst == null: return
		ViewerContainer.inst.current_tab = value
