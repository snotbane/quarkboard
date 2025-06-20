class_name TagList extends HFlowContainer

@export var prefab_tag_instance : PackedScene

func update_tags(note: Note) -> void:
	for child in self.get_children():
		if child is not TagInstance: continue
		self.remove_child(child)
	for tag in note.tags:
		print(tag)
		var node : TagInstance = prefab_tag_instance.instantiate()
		node.populate(tag)
		self.add_child(node)
	# queue_sort()

