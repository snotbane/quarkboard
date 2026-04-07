
extends LineEdit

func _ready() -> void:
	text_submitted.connect(release_focus.unbind(1))


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		release_focus()
