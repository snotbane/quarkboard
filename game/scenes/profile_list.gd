extends SelectList

func _ready() -> void:
	super._ready()
	Machine.global.modified.connect(refresh_list)


func _refresh_list() -> void:
	for profile in Machine.global_profiles:
		if not profile: continue
		var node := selector_scene.instantiate()
		add_child(node)
		node.profile = profile
		# node.set.call_deferred(&"profile", profile)

		if profile == Host.global.active_profile:
			selected_item = node

