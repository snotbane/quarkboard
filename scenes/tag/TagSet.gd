
class_name TagSet extends Resource

enum {
	OK,
	TAG_ALREADY_EXISTS,
	TAG_EMPTY_OR_WHITESPACE,
	TAG_DOES_NOT_EXIST,
}

static var ERROR_STRINGS : Dictionary[int, String] = {
	OK:							"",
	TAG_ALREADY_EXISTS:			"A similar tag already exists.",
	TAG_EMPTY_OR_WHITESPACE:	"Tag must contain at least one non-whitespace character.",
	TAG_DOES_NOT_EXIST:			"No matching or similar tag exists."

}


static func error_string(code: int) -> String:
	return ERROR_STRINGS[code]


var use_references := true
@export_storage var list : Array[Tag]


var _tags_lower_clean : bool = false
var _tags_lower : PackedStringArray
var tags_lower : PackedStringArray :
	get:
		if _tags_lower_clean:
			return _tags_lower

		_refresh_tags_lower()

		return _tags_lower
func _refresh_tags_lower() -> void:
	_tags_lower.clear()
	for tag in list:
		_tags_lower.push_back(tag.name.to_lower())
	_tags_lower_clean = true


func _json_export() -> Variant:
	if use_references:
		var result := PackedStringArray()
		for tag in list:
			result.push_back(tag.name)
		return result
	else:
		var result := JsonResource.serialize(list)
		print(result)
		return result


func _json_import(json) -> void:
	if use_references:
		list.clear()
		# for tag : String in json:
		# 	list.push_back(Tag.get_global_tag(tag))
	else:
		list = JsonResource.deserialize(json)


func has(tag: Tag) -> bool:
	return list.has(tag)
func has_by_name(tag_name: String) -> bool:
	tag_name = Tag.format_string_for_tag(tag_name).to_lower()

	if tag_name.is_empty(): return false
	return tag_name.to_lower() in tags_lower


func find_by_name(tag_name: String) -> Tag:
	tag_name = Tag.format_string_for_tag(tag_name).to_lower()

	for tag in list:
		if tag_name == tag.name.to_lower():
			return tag

	return null


func find_or_create_by_name(tag_name: String) -> Tag:
	var result := find_by_name(tag_name)
	return result if result else Tag.new(tag_name)


func append(tag: Tag) -> void:
	list.push_back(tag)
	tag.changed.connect(emit_changed)

	_refresh_tags_lower()
	emit_changed()

func append_by_name(tag_name: String, palette := UserPalette.SYSTEM) -> int:
	tag_name = Tag.format_string_for_tag(tag_name)

	if tag_name.is_empty(): return TAG_EMPTY_OR_WHITESPACE
	if tag_name.to_lower() in tags_lower: return TAG_ALREADY_EXISTS

	append(find_or_create_by_name(tag_name))
	return OK


func erase(tag: Tag) -> void:
	tag.changed.disconnect(emit_changed)
	list.erase(tag)

	_refresh_tags_lower()
	emit_changed()

func erase_by_name(tag_name: String) -> int:
	tag_name = Tag.format_string_for_tag(tag_name)

	if tag_name.is_empty(): return TAG_EMPTY_OR_WHITESPACE
	if tag_name.to_lower() not in tags_lower: return TAG_DOES_NOT_EXIST

	assert(find_by_name(tag_name) != null, "We checked if the tag \"%s\" exists via the _tags_lower cache and it apparently does, but finding the object itself returns null." % tag_name)

	erase(find_by_name(tag_name))
	return OK


func rename(tag_name: String, new_name: String) -> int:
	tag_name = Tag.format_string_for_tag(tag_name)
	new_name = Tag.format_string_for_tag(new_name)

	if tag_name.is_empty(): return TAG_EMPTY_OR_WHITESPACE
	if new_name.is_empty(): return TAG_EMPTY_OR_WHITESPACE
	if tag_name.to_lower() not in tags_lower: return TAG_DOES_NOT_EXIST
	if new_name.to_lower() in tags_lower: return TAG_ALREADY_EXISTS

	assert(find_by_name(tag_name) != null, "We checked if the tag \"%s\" exists via the _tags_lower cache and it apparently does, but finding the object itself returns null." % tag_name)

	find_by_name(tag_name).name = new_name
	return OK


func clear() -> void:
	if list.is_empty(): return

	for tag in list.duplicate():
		tag.changed.disconnect(emit_changed)
		list.erase(tag)

	_refresh_tags_lower()
	emit_changed()
