
@tool extends Control

const MARGIN_READ_ONLY := 8
const MARGIN_REMOVABLE := 4

signal selected
signal removed

@export var text : String = "Tag" :
	get: return %label.text
	set(value): %label.text = value


@export var removable : bool = false :
	get: return %remove.visible
	set(value):
		%remove.visible = value
		$margin_container.add_theme_constant_override(&"margin_right", MARGIN_REMOVABLE if value else MARGIN_READ_ONLY)
		# add_theme_stylebox_override(&"panel", REMOVABLE_STYLE if value else READ_ONLY_STYLE)


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
