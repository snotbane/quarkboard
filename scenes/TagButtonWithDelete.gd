
@tool extends PanelContainer

signal selected
signal removed


@export var text : String = "Tag" :
	get: return $buttons/select.text
	set(value):	$buttons/select.text = value


func _ready() -> void:
	# $buttons.modulate = Color.TRANSPARENT

	$buttons/select.pressed.connect(selected.emit)
	$buttons/remove.pressed.connect(removed.emit)

	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

	_mouse_exited()


func _mouse_entered() -> void:
	# $label.modulate = Color.TRANSPARENT
	# $buttons.modulate = Color.WHITE
	$buttons/remove.modulate = Color.WHITE


func _mouse_exited() -> void:
	# $label.modulate = Color.WHITE
	# $buttons.modulate = Color.TRANSPARENT
	$buttons/remove.modulate = Color.TRANSPARENT
