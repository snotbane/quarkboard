extends SelectItem

var _profile : Profile
@export var profile : Profile :
	get: return _profile
	set(value):
		if _profile == value: return

		if _profile:
			_profile.modified.disconnect(refresh)

		_profile = value
		refresh.call_deferred()

		if _profile:
			_profile.modified.connect(refresh)

func refresh() -> void:
	$margin_container/hbox/icon.texture = _profile.icon if _profile else null
	$margin_container/hbox/vbox/name.text = _profile.name if _profile else String()
	$margin_container/hbox/vbox/location.text = _profile.save_dir if _profile else String()


func _get_selection_object() -> Variant:
	return _profile
