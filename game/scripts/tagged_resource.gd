class_name TaggedResource extends JsonResource

const K_TAGS := &"tags"

signal tags_changed

func _init() -> void:
	super._init()

	tags = []


func _export_json(json: Dictionary) -> void:
	json[K_TAGS] = tags.map(func(tag): return tag.export_json())

func _import_json(json: Dictionary) -> void:
	tags.clear()
	for tag_json in json[K_TAGS]: tags.push_back(Tag.new_from_json(tag_json))

@export var tags : Array[Tag]

func find_tag(tag_name: String) -> Tag:
	for tag in tags: if tag.name == tag_name: return tag
	return null

func get_or_add_tag(tag_name: String) -> Tag:
	var existing := find_tag(tag_name)
	if existing: return existing

	var result := Tag.new()
	result.name = tag_name
	tags.push_back(result)
	tags.sort()
	tags_changed.emit()
	return result

func destroy_tag(id: String) -> Tag:
	var tag := find_tag(id)

	tag.destroy()
	tags.erase(tag)
	tags.sort()
	tags_changed.emit()
	return tag

func change_tag_name(id: String, new_name: String) -> void:
	var tag := find_tag(id)
	tag.change_name(new_name, null)

func change_tag_status(id: String, new_status: Tag.Status) -> void:
	var tag := find_tag(id)
	tag.change_status(new_status, null)