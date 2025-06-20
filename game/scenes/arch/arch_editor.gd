class_name ArchEditor extends NoteInstance

@export var main_viewport : Control
@export var title_edit : LineEdit
@export var text_edit : TextEdit
@export var last_modified_label : Label

func _on_set_note() -> void:
	main_viewport.visible = note != null

	text_edit.editable = note != null
	text_edit.text = note.text if note else ""

	title_edit.editable = note != null
	title_edit.placeholder_text = note.placeholder_title if note else ""
	title_edit.text = note.title if note else ""

	last_modified_label.tooltip_text = note.time_tooltip if note else ""

func _on_note_modified() -> void:
	last_modified_label.tooltip_text = note.time_tooltip


# func _ready() -> void:
# 	super._ready()


func _process(delta: float) -> void:
	if not note: return

	last_modified_label.text = note.last_modified_short_blurb


func _on_title_edit_text_changed() -> void:
	note.title = title_edit.text


func _on_text_edit_text_changed() -> void:
	note.text = text_edit.text
	title_edit.placeholder_text = note.placeholder_title
