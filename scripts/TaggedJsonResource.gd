
class_name TaggedJsonResource extends JsonResource

@export_storage var tags : TagSet

func _init() -> void:
	super._init()

	tags = TagSet.new()

	tags.changed.connect(save)
