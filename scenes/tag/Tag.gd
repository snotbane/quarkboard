
class_name Tag extends Resource


const DIR_NAME := "tags"
const MAX_NAME_LENGTH := 50


static var REGEX_REMOVE_WHITESPACE := RegEx.create_from_string(r"^\s+|\s+$|[\n\t]+|(?:\b +(?= )\b)")


static func format_string_for_tag(s: String) -> String:
	return REGEX_REMOVE_WHITESPACE.sub(s, "")


static func get_global_tag(tag_name: String) -> Tag:
	return Machine.active_profile.tags.find_by_name(tag_name)


@export_storage var name : String :
	set(value):
		if name == value: return

		name = value
		emit_changed()


@export_storage var palette : int :
	set(value):
		if palette == value: return

		palette = value
		emit_changed()


func _init(__name__: String = "", __palette__ : int = UserPalette.SYSTEM) -> void:
	# super._init()

	name = __name__
	palette = __palette__


func _to_string() -> String:
	return name
