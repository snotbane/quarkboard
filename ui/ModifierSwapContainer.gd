class_name ModifierSwapper
extends Node

@export var default: Control
@onready var current_default: Control = default
@export var swap_toggled: bool = false
@export var shortcuts: Dictionary[Shortcut, Control]


func _ready() -> void:
	if swap_toggled:
		var relevant_children := shortcuts.values()
		relevant_children.push_back(default)
		for control: Control in relevant_children:
			if control is not BaseButton or not control.toggle_mode: continue
			control.toggled.connect(_button_toggled.bind(control))


func _button_toggled(toggled: bool, button: BaseButton) -> void:
	var k: Shortcut = shortcuts.find_key(button)
	if k == null: k = shortcuts.find_key(default)

	if toggled:
		shortcuts[k] = default
		current_default = button
	else:
		shortcuts[k] = button
		current_default = default


func _input(event: InputEvent) -> void:
	if event is not InputEventKey or event.is_echo(): return

	for k in shortcuts:
		if not k.matches_event(event): continue

		shortcuts[k].visible = event.is_pressed()
		if not shortcuts[k].visible:
			current_default.show()

		break
