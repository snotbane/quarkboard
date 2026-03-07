
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


@onready var icon : TextureRect = $margin_container/h_box_container/icon
@onready var icon_error : TextureRect = $margin_container/h_box_container/error
@onready var label_name : Label = $margin_container/h_box_container/v_box_container/name
@onready var label_location : Label = $margin_container/h_box_container/v_box_container/location


func _get_selection_object() -> Variant:
	return _profile
func _set_selection_object(value: Variant) -> void:
	_profile = value


func refresh() -> void:
	var is_valid := _profile.is_valid if _profile else false


	button.disabled = not is_valid
	icon_error.visible = not is_valid
	icon.visible = is_valid
	icon.texture = _profile.icon if _profile else null
	label_name.text = _profile.name if _profile else String()
	label_location.text = _profile.save_dir if _profile else String()
	label_location.tooltip_text = label_location.text
	label_location.mouse_filter = Control.MOUSE_FILTER_IGNORE if is_valid else Control.MOUSE_FILTER_PASS


func _on_selected() -> void:
	profile.make_active()

func _on_unselected() -> void:
	if Host.active_profile == profile:
		Host.active_profile = null



