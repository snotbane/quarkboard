class_name NoteList extends SelectList

# @export var prefab_sticky : PackedScene


# func create_new_sticky(entry := Entry.new()) -> Node:
# 	var result : EntryInstance = prefab_sticky.instantiate()
# 	self.add_child(result)
# 	result.entry = entry
# 	return result


func _ready() -> void:
	super._ready()
	Host.global.profile_changed.connect(refresh_list)


func _refresh_list() -> void:
	if not Host.global.active_profile: return
	for entry in Host.global.active_profile.entries:
		var result : SelectItem = selector_scene.instantiate()
		self.add_child(result)
		result.selection_object = entry
