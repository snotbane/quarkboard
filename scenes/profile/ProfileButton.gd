extends Control

var _profile: Profile
var profile: Profile:
	get: return _profile
	set(value):
		_profile = value

		if not is_node_ready():
			await ready

		$profile.resource = _profile


func populate(element: Profile):
	profile = element


func compare(other: Node) -> bool:
	if other is not Control: return false

	return self.profile.name < other.profile.name
