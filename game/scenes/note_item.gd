extends SelectItem

@export var note_instance : NoteInstance

func _get_selection_object() -> Variant:
	return note_instance.note
func _set_selection_object(value: Variant) -> void:
	note_instance.note = value
