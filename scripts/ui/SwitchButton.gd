## Acts as a toggle between two buttons while keeping them separate.
@tool extends PanelContainer

@onready var button_a : Button = get_child(0)
@onready var button_b : Button = get_child(1)

var in_progress : bool = false

func _ready() -> void:
	button_a.visibility_changed.connect(_button_a_visibility_changed)
	button_a.pressed.connect(button_a.hide)

	button_b.visibility_changed.connect(_button_b_visibility_changed)
	button_b.pressed.connect(button_b.hide)


func _button_a_visibility_changed() -> void:
	if in_progress: return
	in_progress = true

	button_b.visible = not button_a.visible

	in_progress = false


func _button_b_visibility_changed() -> void:
	if in_progress: return
	in_progress = true

	button_a.visible = not button_b.visible

	in_progress = false
