
extends Control

@onready var container : Control = GlobalNode.get_global_node(&"quark_editor_container")

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)


func _visibility_changed() -> void:
	if visible: return

	for child in container.get_children():
		if child is not Control: continue
		child.queue_free()
