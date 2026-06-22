class_name Game extends Node

const PROFILES_MANAGER_SCENE := preload("res://scenes/profile/ProfilesManager.tscn")

static var inst: Game

func _ready() -> void:
	inst = self

	$machine.resource = Machine.new()
	Machine.inst.touch()

	if not Machine.inst.profile_active_exists:
		$profiles_manager_window.show()


func toggle_profiles_manager_window() -> void:
	$profiles_manager_window.toggle_or_grab_focus()
