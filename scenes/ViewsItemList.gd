
extends ItemList

const NULL_PROFILE_ICON := preload("uid://uh3pt61ejjbp")

func _ready() -> void:
	Machine.inst.active_profile_changed.connect(_active_profile_changed)


func _active_profile_changed() -> void:
	set_item_icon(0, Machine.active_profile.icon if Machine.active_profile else NULL_PROFILE_ICON)
	set_item_disabled(0, Machine.active_profile == null)
