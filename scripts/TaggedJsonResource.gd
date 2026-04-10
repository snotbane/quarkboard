
class_name TaggedJsonResource extends JsonResource

var other : Resource


func _init_tags() -> void:
	tags = TagSet.new()
	tags.changed.connect(save)
	print("is_connected: ", tags.changed.is_connected(save))


func _tag_matches_text(tag: Tag, text: String) -> bool:
	return tag.name == text


func _create_tag_by_name(text: String) -> void:
	print("is_connected: ", tags.changed.is_connected(save))
	tags.push_back(Tag.new(text))
