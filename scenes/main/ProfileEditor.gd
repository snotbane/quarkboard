extends Control

var _profile: Profile
var profile: Profile:
	get: return _profile
	set(value):
		_profile = value

		if not is_node_ready():
			await ready

		$resource_component.resource = _profile


func populate(element: Profile):
	profile = element


func move_to_folder(path: String) -> void:
	profile.move(path)
