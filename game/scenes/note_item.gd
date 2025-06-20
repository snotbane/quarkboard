extends SelectItem

@export var entry_instance : EntryInstance

func _get_selection_object() -> Variant:
	return entry_instance.entry
func _set_selection_object(value: Variant) -> void:
	entry_instance.entry = value
