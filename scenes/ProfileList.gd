
extends SelectList

func _ready() -> void:
	# super._ready()
	# Machine.inst.modified.connect(refresh_list)
	Host.inst.profile_changed.connect(_profile_changed)


func _refresh_list() -> void:
	for profile in Machine.inst.profiles:
		if not profile: continue
		var item := item_scene.instantiate()
		add_child(item)
		item.profile = profile

		if profile == Host.active_profile:
			single_select(item)


func _profile_changed() -> void:
	# selected_object = Host.active_profile
	pass



func _on_create_dialog_file_selected(path: String) -> void:
	if DirAccess.dir_exists_absolute(path):
		printerr("Can't create new profile. A profile with the same file path already exists.")
		return

	var err := DirAccess.make_dir_recursive_absolute(path)
	if err != OK:
		printerr("Something went wrong: (code %s)" % err)
		return

	print("create")

	var profile_path := path.path_join(Profile.PATH)
	var profile := Profile.new(profile_path)

	profile.make_active()


func _on_import_dialog_file_selected(path: String) -> void:
	if not DirAccess.dir_exists_absolute(path):
		printerr("Can't import profile. The path does not exist.")
		return

	var profile_paths_found := Myth.get_paths_in_folder(path, Profile.REGEX_PATTERN_PROFILE_PATH)

	print("import")

	var last_imported : Profile
	for profile_path in profile_paths_found:
		last_imported = Profile.new(profile_path.path_join(Profile.PATH))

	if profile_paths_found.size() == 1:
		last_imported.make_active()



func _on_move_dialog_dir_selected(dir: String) -> void:
	Host.active_profile.move(dir)


func _on_copy_dialog_dir_selected(dir: String) -> void:
	Host.active_profile.copy(dir)


func _on_hide_dialog_confirmed() -> void:
	Host.active_profile.hide()


