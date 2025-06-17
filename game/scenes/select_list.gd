class_name SelectList extends BoxContainer

@export var selector_scene : PackedScene

func _ready() -> void:
	refresh_list()
	ProfileList.global.modified.connect(refresh_list)

func refresh_list() -> void:
	for child in get_children(): child.queue_free()

	for profile in ProfileList.global_profiles:
		var node := selector_scene.instantiate()
		add_child(node)
		node.set.call_deferred(&"profile", profile)
