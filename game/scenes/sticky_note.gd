extends GraphNode

@export var inline_text_editor : TextEdit

@export var sidebar : Control
@onready var sidebar_hbox : HBoxContainer = sidebar.get_parent()

@export var add_to_title : Control
@onready var title_container : Control = self.get_child(0, true)
@onready var title_label : Label = title_container.get_child(0, true)


func _ready() -> void:
	title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_WORD_ELLIPSIS

	add_to_title.get_parent().remove_child(add_to_title)
	title_container.add_child(add_to_title)
	add_to_title.visible = true


func _on_sidebar_visibility_changed() -> void:
	self.size.x += (sidebar.size.x + sidebar_hbox.get_theme_constant(&"separation")) * (1.0 if sidebar.visible else -1.0)


func _on_text_changed() -> void:
	update_title()

func update_title() -> void:
	# self.title = note.placeholder_title
	# self.title = ArchEditor.get_title_from_text(inline_text_editor.text)
	pass
