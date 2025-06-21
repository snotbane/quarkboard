extends SelectItem

var _profile : Profile
var profile : Profile :
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
	$button.disabled = not _profile.is_valid
	$margin_container/hbox/icon_error.visible = not _profile.is_valid
	$margin_container/hbox/icon.visible = _profile.is_valid
	$margin_container/hbox/icon.texture = _profile.icon if _profile else null
	$margin_container/hbox/vbox/name.text = _profile.name if _profile else String()
	$margin_container/hbox/vbox/location.text = _profile.save_dir if _profile else String()
	$margin_container/hbox/vbox/location.tooltip_text = $margin_container/hbox/vbox/location.text
	$margin_container/hbox/vbox/location.mouse_filter = Control.MOUSE_FILTER_IGNORE if _profile.is_valid else Control.MOUSE_FILTER_PASS



func _get_selection_object() -> Variant:
	return _profile
func _set_selection_object(value: Variant) -> void:
	_profile = value


func _on_selected() -> void:
	profile.make_active()

func _on_unselected() -> void:
	if Host.global.active_profile == profile:
		Host.global.active_profile = null

