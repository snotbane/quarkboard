@tool class_name StringField extends Field

var _allow_empty : bool
@export var allow_empty : bool :
	get: return _allow_empty
	set(value):
		if _allow_empty == value: return
		_allow_empty = value
		validate()

@export var _field_value : String :
	get: return $hbox/input_area/line_edit.text if self.find_child("line_edit") else ""
	set(value):
		if not self.find_child("line_edit"): return
		$hbox/input_area/line_edit.text = value
		$hbox/input_area/line_edit.tooltip_text = value

func _get_validation() -> String :
	if allow_empty or not field_value.is_empty(): return String()
	return "This field cannot be empty."
