class_name ProfileList extends JsonResource

const PATH := "user://profiles.json"
const K_PROFILE_LOCATIONS := "profile_locations"

static var global : ProfileList = ProfileList.new(PATH)

static var profiles : Array

func _import_json(json: Dictionary) -> void:
	profiles = json[K_PROFILE_LOCATIONS].map(func(profile: String) -> Profile : return Profile.new(profile))

func _export_json(json: Dictionary) -> void:
	json.merge({
		K_PROFILE_LOCATIONS: profiles.map(func(profile: Profile) -> String : return profile.save_path)
	})

static func add_profile(profile: Profile) -> void:
	if ProfileList.global:
		_internal_add_profile(profile)
	else:
		_internal_add_profile.call_deferred(profile)
static func _internal_add_profile(profile: Profile) -> void:
	if profiles.has(profile): return
	profiles.push_back(profile)
	ProfileList.global.commit_changes()
	prints("Profiles:", profiles)

