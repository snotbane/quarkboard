
@tool extends PanelContainer

signal navigated
signal removed


@export var text : String = "Tag" :
	get: return $label.text
	set(value):
		$label.text = value
		$buttons/navigate.text = value


func _ready() -> void:
	$buttons.modulate = Color.TRANSPARENT

	$buttons/navigate.pressed.connect(navigated.emit)
	$buttons/remove.pressed.connect(removed.emit)

	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _mouse_entered() -> void:
	$label.modulate = Color.TRANSPARENT
	$buttons.modulate = Color.WHITE

func _mouse_exited() -> void:
	$label.modulate = Color.WHITE
	$buttons.modulate = Color.TRANSPARENT
