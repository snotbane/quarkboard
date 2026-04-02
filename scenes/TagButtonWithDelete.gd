
@tool extends Control

const READ_ONLY_STYLE := preload("uid://dcaa7v1yusphs")
const REMOVABLE_STYLE := preload("uid://be8tud0vjigvc")

signal selected
signal removed

@export var text : String = "Tag" :
	get: return %select.text
	set(value): %select.text = value


@export var removable : bool = false :
	get: return %remove.visible
	set(value):
		%remove.visible = value
		add_theme_stylebox_override(&"panel", REMOVABLE_STYLE if value else READ_ONLY_STYLE)


var hovered : bool = false :
	set(value):
		hovered = value
		%remove.self_modulate = Color.WHITE if value else Color.TRANSPARENT


func _ready() -> void:

	%select.pressed.connect(selected.emit)
	%remove.pressed.connect(removed.emit)

	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

	_mouse_exited()


func _mouse_entered() -> void:
	hovered = true


func _mouse_exited() -> void:
	hovered = false
