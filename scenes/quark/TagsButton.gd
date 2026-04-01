
extends IconToggleButton

signal selected(tag: String)
signal removed(tag: String)

@export var socket : ResourceSocket

func _ready() -> void:
	%list.socket = socket
	%list.selected.connect(selected.emit)
	%list.removed.connect(removed.emit)
