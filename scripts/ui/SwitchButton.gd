## Acts as a toggle between two buttons while keeping them separate.
@tool extends PanelContainer

@export var switch_on_input : bool = false

@onready var button_a : Button = get_child(0)
@onready var button_b : Button = get_child(1)

var in_progress : bool = false

func _ready() -> void:
	button_a.visibility_changed.connect(_button_a_visibility_changed)
	button_b.visibility_changed.connect(_button_b_visibility_changed)

	if not switch_on_input:
		button_a.pressed.connect(button_a.hide)
		button_b.pressed.connect(button_b.hide)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_shift"):
		button_a.hide()
	elif event.is_action_released(&"ui_shift"):
		button_a.show()


func _button_a_visibility_changed() -> void:
	if in_progress or not is_visible_in_tree(): return
	in_progress = true

	button_b.visible = not button_a.visible

	in_progress = false


func _button_b_visibility_changed() -> void:
	if in_progress or not is_visible_in_tree(): return
	in_progress = true

	button_a.visible = not button_b.visible

	in_progress = false
