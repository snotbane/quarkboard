extends Control

signal visibility_changed_with_value(visible: bool)

var profile: Profile:
	get: return $profile.resource
	set(value): $profile.resource = value

func populate(element: Profile) -> void:
	if not is_node_ready():
		await ready

	profile = element

	if profile.is_active:
		show.call_deferred()


# func _init() -> void:
# 	visibility_changed.connect(func() -> void:
# 		visibility_changed_with_value.emit(visible)
# 	)
