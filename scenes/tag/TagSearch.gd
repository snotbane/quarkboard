
extends LineEdit

@export var tag_button_container : TagButtonContainer
@export_enum("None", "Create") var submit_list_action : int
@export_enum("None", "Select All", "Clear") var submit_self_action : int


func _ready() -> void:
	match submit_self_action:
		1:	text_submitted.connect(select_all.unbind(1))
		2:	text_submitted.connect(clear.unbind(1))

	if tag_button_container:
		text_changed.connect(tag_button_container.set_filter)

		match submit_list_action:
			1: text_submitted.connect(tag_button_container.toggle_or_create_tag_from_text)

