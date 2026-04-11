
@tool class_name PaletteSelector extends BoxContainer

const PANEL_STYLE := preload("uid://5uwyi4lx8o40")

signal option_hovered(idx: int)
signal option_selected(idx: int)

func _ready() -> void:
	for i in UserPalette.MAX:
		var button := Panel.new()
		button.add_theme_stylebox_override(&"panel", PANEL_STYLE)
		button.focus_mode = Control.FOCUS_ALL
		button.custom_minimum_size = Vector2(15, 24)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.self_modulate = UserPalette.get_palette(i).normal_color
		button.mouse_entered.connect(option_hovered.emit.bind(i))
		button.gui_input.connect(_button_gui_input.bind(i))
		add_child(button, false, INTERNAL_MODE_FRONT)


func show_with_palette(idx: int) -> void:
	show()
	get_child(idx, true).grab_focus.call_deferred()


func _button_gui_input(event: InputEvent, idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		option_selected.emit(idx)

	elif event.is_action_pressed(&"ui_cancel"):
		option_selected.emit(-1)
