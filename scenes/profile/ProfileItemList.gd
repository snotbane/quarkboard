extends ItemList

var machine_socket: ResourceNode
var index_profiles: Dictionary[int, Profile]


func _init() -> void:
	machine_socket = ResourceNode.add_child_socket(self )
	item_selected.connect(_item_selected)

func _resource_changed() -> void:
	clear()

	if machine_socket.resource == null: return
	assert(machine_socket.resource is Machine, "Expected machine_socket resource to be a Machine.")

	print("machine_socket.resource.profiles : %s" % [machine_socket.resource.profiles])

	for profile: Profile in machine_socket.resource.profiles:
		var idx := add_item(profile.display_name, profile.icon)
		index_profiles[idx] = profile

	select(machine_socket.resource.active_profile_idx)

	sort_items_by_text()


func _item_selected(idx: int) -> void:
	Machine.active_profile = index_profiles[idx]


func get_profile_index(profile: Profile) -> int:
	return index_profiles.find_key(profile)


func _profile_changed(profile: Profile) -> void:
	var idx := get_profile_index(profile)
	set_item_text(idx, profile.display_name)
	set_item_icon(idx, profile.icon)


func _on_create_dialog_file_selected(path: String) -> void:
	if DirAccess.dir_exists_absolute(path):
		printerr("Can't create new profile. A profile with the same file path already exists.")
		return

	if Profile.find_parent_from_path(path):
		printerr("Can't create a new profile inside of another profile directory.")
		return

	var profile := Profile.new()
	profile.save(path)

	profile.make_active()


func _on_import_dialog_dir_selected(path: String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		printerr("Can't import profile. The path does not exist.")
		return

	if Machine.profiles.find_key(path) != null:
		printerr("This profile is already imported.")
		return

	var profile_paths_found := Myth.get_paths_in_folder(path, Profile.REGEX_PATTERN_PROFILE_PATH)

	var last_imported: Profile
	for profile_path in profile_paths_found:
		last_imported = Profile.new()
		last_imported.load(profile_path)

	if profile_paths_found.size() == 1:
		last_imported.make_active()
