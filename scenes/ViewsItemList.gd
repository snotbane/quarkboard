
extends ItemList

const NULL_PROFILE_ICON := preload("uid://uh3pt61ejjbp")

func _ready() -> void:
	Host.inst.profile_changed.connect(_profile_changed)


func _profile_changed() -> void:
	set_item_icon(0, Host.active_profile.icon if Host.active_profile else NULL_PROFILE_ICON)
	set_item_disabled(0, Host.active_profile == null)
