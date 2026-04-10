
class_name TaggedJsonResource extends JsonResource

signal tags_changed


func _init_tags() -> void:
	tags = TagSet.new()
	tags.changed.connect(save)
	tags.changed.connect(tags_changed.emit)


func _tag_matches_text(tag: Tag, text: String) -> bool:
	return tag.name == text


func _create_tag_by_name(text: String) -> void:
	tags.push_back(Tag.new(text))
