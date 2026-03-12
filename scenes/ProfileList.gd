
extends SelectList

func _ready() -> void:
	for profile in Machine.profiles.keys():
		if not profile: continue
		_profile_added(profile, false)

	Machine.inst.profile_added.connect(_profile_added)
	Machine.inst.profile_removed.connect(_profile_removed)
	Machine.inst.active_profile_changed.connect(_active_profile_changed, ConnectFlags.CONNECT_DEFERRED)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			Machine.inst.save()


func _profile_added(profile: Profile, make_active: bool = true) -> void:
	var item := item_scene.instantiate()
	add_child(item)

	item.profile = profile

	if make_active:
		profile.make_active()


func _profile_removed(profile: Profile) -> void:
	get_item_from_obj(profile).queue_free()


func _active_profile_changed() -> void:
	single_select(get_item_from_obj(Machine.active_profile))


func _on_create_dialog_file_selected(path: String) -> void:
	if DirAccess.dir_exists_absolute(path):
		printerr("Can't create new profile. A profile with the same file path already exists.")
		return

	if Profile.find_parent_from_path(path):
		printerr("Can't create a new profile inside of another profile directory.")
		return

	# var err := DirAccess.make_dir_recursive_absolute(path)
	# if err != OK:
	# 	printerr("Something went wrong: (code %s)" % err)
	# 	return

	var profile := Profile.new()
	profile.save(path)

	profile.make_active()


func _on_import_dialog_file_selected(path: String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		printerr("Can't import profile. The path does not exist.")
		return

	if Machine.profiles.find_key(path) != null:
		printerr("This profile is already imported.")
		return

	var profile_paths_found := Myth.get_paths_in_folder(path, Profile.REGEX_PATTERN_PROFILE_PATH)

	var last_imported : Profile
	for profile_path in profile_paths_found:
		last_imported = Profile.new()
		last_imported.load(profile_path)

	if profile_paths_found.size() == 1:
		last_imported.make_active()


func _on_move_dialog_dir_selected(dir: String) -> void:
	Machine.active_profile.move(dir)


func _on_copy_dialog_dir_selected(dir: String) -> void:
	Machine.active_profile.copy(dir, false)


func _on_hide_dialog_confirmed() -> void:
	Machine.active_profile.hide()


