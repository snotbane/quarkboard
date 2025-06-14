class_name StickyContainer extends Container

@export var prefab_sticky : PackedScene


func create_new_sticky(entry := Entry.new()) -> Node:
	var result : EntryInstance = prefab_sticky.instantiate()
	self.add_child(result)
	result.entry = entry
	return result


func _ready() -> void:
	for entry in Entry.REGISTRY:
		create_new_sticky(entry)
