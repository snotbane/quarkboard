## Pops up next to its parent, trying to stay within the parent window.
class_name ButtonPopupPanel extends PopupPanel

@onready var button : BaseButton = Myth.find_ancestor_of_type(self, "BaseButton")

func _ready() -> void:
	print("Myth.find_ancestor_of_type(self, \"BaseButton\") : %s" % [ Myth.find_ancestor_of_type(self, "BaseButton") ])

	button.toggled.connect(_on_parent_toggled)
	popup_hide.connect(_release_parent)


func _on_parent_toggled(toggle_mode: bool) -> void:
	if toggle_mode:
		popup(get_parent().get_global_rect())
	else:
		hide()


func _release_parent() -> void:
	button.button_pressed = false
