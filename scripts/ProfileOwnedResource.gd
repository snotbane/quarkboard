
class_name ProfileOwnedResource extends JsonResource

static func generate_profile_save_path(profile: Profile, sub_folder: String) -> String:
	return profile.file_dir.path_join(sub_folder).path_join(generate_save_name())
