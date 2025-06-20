class_name Host extends Node

## This is the host node which contains all static data for the program and emits signals for stuff.

static var global : Host

signal profile_changed

var _active_profile : Profile
@export var active_profile : Profile :
	get: return _active_profile
	set(value):
		if _active_profile == value: return
		_active_profile = value

		profile_changed.emit()


func _ready() -> void:
	if global:
		push_error("Host already exists, this is a singleton!")
		return

	global = self

