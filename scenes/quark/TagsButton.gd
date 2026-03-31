
extends IconToggleButton

signal selected(tag: String)
signal removed(tag: String)

func _ready() -> void:
	%list.selected.connect(selected.emit)
	%list.removed.connect(removed.emit)
