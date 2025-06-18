extends Control

var _profile : Profile
@export var profile : Profile :
	get: return _profile
	set(value):
		if _profile == value: return

		if _profile:
			_profile.modified.disconnect(refresh_profile)

		_profile = value
		refresh_profile()

		if _profile:
			_profile.modified.connect(refresh_profile)
func refresh_profile() -> void:
	visible = _profile != null
	if not _profile: return

	if not $vbox/h_box_container/name.is_editing():
		$vbox/h_box_container/name.text = _profile.name
	$vbox/location.text = _profile.save_dir
	# $vbox/icon.texture = _profile.icon if _profile.icon else null
	# $vbox/grid/move_button/move_dialog.default_path = _profile.save_dir

func set_profile(__profile__: Profile) -> void:
	profile = __profile__


func _ready() -> void:
	visible = _profile != null


func _on_create_dialog_file_selected(path: String) -> void:
	if DirAccess.dir_exists_absolute(path): ErrorOverlay.global_push("Can't create new profile. A profile with the same name already exists."); return

	var err := DirAccess.make_dir_recursive_absolute(path)
	if err != OK: ErrorOverlay.global_push("Something went wrong? (code %s)" % err); return

	var profile_path := path.path_join(Profile.PATH)
	Profile.new(profile_path)


func _on_import_dialog_dir_selected(dir: String) -> void:
	if not DirAccess.dir_exists_absolute(dir): ErrorOverlay.global_push("The selected directory does not exist."); return

	var profile_paths_found := MincuzUtils.get_paths_in_folder(dir, Profile.RE_PROFILE_PATH)

	var last_imported : Profile
	for profile_path in profile_paths_found:
		last_imported = Profile.new(profile_path.path_join(Profile.PATH))

	if profile_paths_found.size() == 1:
		last_imported.make_active()


func _on_move_dialog_dir_selected(dir: String) -> void:
	profile.move(dir)


func _on_copy_dialog_dir_selected(dir: String) -> void:
	profile.copy(dir)


func _on_hardcopy_dialog_dir_selected(dir: String) -> void:
	profile.hardcopy(dir)


func _on_reveal_button_pressed() -> void:
	profile.reveal()


func _on_hide_dialog_confirmed() -> void:
	profile.hide()


func _on_delete_dialog_confirmed() -> void:
	profile.delete()


func _on_name_text_changed(new_text: String) -> void:
	profile.name = new_text
