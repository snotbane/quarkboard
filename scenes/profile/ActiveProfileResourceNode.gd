extends ResourceNode

func _ready() -> void:
	Machine.inst.active_profile_changed.connect(_active_profile_changed)


func _active_profile_changed() -> void:
	resource = Machine.active_profile
