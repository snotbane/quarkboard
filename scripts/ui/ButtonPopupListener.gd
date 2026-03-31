
extends Node

@export var watch_node : Control
@onready var parent : BaseButton = get_parent()


func _ready() -> void:
	parent.toggled.connect(watch_node.set_visible)
	watch_node.visibility_changed.connect(_watch_node_visibility_changed)

	_watch_node_visibility_changed()


func _watch_node_visibility_changed() -> void:
	parent.button_pressed = watch_node.visible