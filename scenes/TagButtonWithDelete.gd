
@tool extends Control

signal selected
signal removed

@export var text : String = "Tag" :
	get: return $readonly.text
	set(value):	$readonly.text = value

@export var removable : bool = false :
	get: return $readonly.visible
	set(value): $readonly.visible = value


func _ready() -> void:
	# $buttons.modulate = Color.TRANSPARENT

	$readonly.pressed.connect(selected.emit)
	$removable/buttons/select.pressed.connect(selected.emit)
	$removable/buttons/remove.pressed.connect(removed.emit)

	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

	_mouse_exited()


func _mouse_entered() -> void:
	# $label.modulate = Color.TRANSPARENT
	# $buttons.modulate = Color.WHITE
	$removable/buttons/remove.modulate = Color.WHITE


func _mouse_exited() -> void:
	# $label.modulate = Color.WHITE
	# $buttons.modulate = Color.TRANSPARENT
	$removable/buttons/remove.modulate = Color.TRANSPARENT
