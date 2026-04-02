
@tool extends MasonryContainer

func _sort_children(a: Control, b: Control) -> bool:
	if a is not FlatQuarkViewer or b is not FlatQuarkViewer: return false
	if a.quark == null or b.quark == null: return false

	return a.quark.time_text_modified > b.quark.time_text_modified

