## This is the host node which contains all static data for the program and emits signals for stuff.
class_name Host extends Node

static var inst : Host

signal profile_changed

var _active_profile : Profile
@export var active_profile : Profile :
	get: return _active_profile
	set(value):
		if _active_profile == value: return
		if value and not value.is_valid:
			push_error("Cannot set active profile to an invalid profile.")
			return

		_active_profile = value

		profile_changed.emit()


func _ready() -> void:
	inst = self


func _exit_tree() -> void:
	Machine.inst.save()
