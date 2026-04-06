
extends LineEdit

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	text_submitted.connect(hide.unbind(1))


func _visibility_changed() -> void:
	if visible:
		grab_focus.call_deferred()


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		hide()
