
extends ItemList

const ERROR_ICON := preload("uid://uh3pt61ejjbp")

func _ready() -> void:
	Host.inst.profile_changed.connect(_profile_changed)


func _profile_changed() -> void:
	set_item_icon(0, Host.inst.active_profile.icon if Host.inst.active_profile else ERROR_ICON)
