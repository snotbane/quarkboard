## Abstract class for a view in which to organize [Quark]s.
class_name Board extends TaggedJsonResource

const DIR_NAME := "boards"
const ICON_UNKNOWN := preload("uid://uh3pt61ejjbp")


@export_storage var name : String


func _init() -> void:
	name = _get_default_name()
	super._init()


func _ready() -> void:
	if parent.boards.has(self): return

	parent.boards.push_back(self)
	parent.boards_changed.emit()


var icon : Texture2D :
	get: return _get_default_icon()


func _get_default_name() -> String:
	return ""


func _get_default_icon() -> Texture2D:
	assert(false, "Expected override.")
	return ICON_UNKNOWN


func _get_viewer_scene() -> PackedScene:
	assert(false, "Expected override.")
	return null
