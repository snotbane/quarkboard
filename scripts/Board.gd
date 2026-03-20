## Abstract class for a view in which to organize [Quark]s.
class_name Board extends JsonResource

const DIR_NAME := "boards"
const ICON_UNKNOWN := preload("uid://uh3pt61ejjbp")


@export_storage var name : String

## A list of filters to include or exclude. For now, this will only filter for tags.
## E.g. [ "Ideas", "!Journal" ] will include all notes with the "Ideas" tag except ones with the "Journal" tag.
@export_storage var filters : PackedStringArray


func _init() -> void:
	name = _get_default_name()
	super._init()


func _ready() -> void:
	parent.board_added.emit(self)


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
