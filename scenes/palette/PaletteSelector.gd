
class_name PaletteSelector extends Container

signal option_hovered(idx: int)
signal option_selected(idx: int)

func _ready() -> void:
	for i in get_child_count():
		var button : Button = get_child(i)
		button.self_modulate = UserPalette.get_palette(i).normal_color
		button.mouse_entered.connect(option_hovered.emit.bind(i))
		button.pressed.connect(option_selected.emit.bind(i))
		button.gui_input.connect(_button_gui_input)

# 	visibility_changed.connect(_visibility_changed)

# func _visibility_changed() -> void:
# 	if not is_visible_in_tree(): return


func show_with_palette(idx: int) -> void:
	show()
	get_child(idx).grab_focus.call_deferred()


func _button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		option_selected.emit(-1)

