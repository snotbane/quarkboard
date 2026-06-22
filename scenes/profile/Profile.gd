class_name Profile extends JsonResource

const FILE_EXTENSION := "qbdp"

const ICON_DEFAULT := preload("res://icons/profile_icons/00_user_alt_1.svg")
const ICON_BROKEN := preload("res://icons/triangle_exclamation.svg")


@export_storage var name: String
var name_safe: String:
	get: return name if name else "New Profile"


@export_storage var icon: Texture2D
var icon_safe: Texture2D:
	get: return icon if icon else ICON_DEFAULT


@export_storage var quarks: Array


## Returns true if this profile is the currently active one, according to [Machine].
var is_active: bool:
	get: return Machine.inst.profile_active == self
	set(value):
		print("value : %s" % [value])
		if value:
			Machine.inst.profile_active = self
			emit_changed()
		elif is_active:
			Machine.inst.profile_active = null
			emit_changed()


func _get_save_as_dir_default() -> bool:
	return true


func _tags_init() -> Variant:
	return TagSuite.new(false)


func make_active() -> void:
	Machine.inst.profile_active = self


func unlink() -> void:
	Machine.inst.remove_profile(self)
