extends SelectList

func _refresh_list() -> void:
	for profile in Machine.global_profiles:
		if not profile: continue
		var node := selector_scene.instantiate()
		add_child(node)
		node.set.call_deferred(&"profile", profile)
