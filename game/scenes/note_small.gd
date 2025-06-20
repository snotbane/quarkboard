extends NoteInstance

@export var title_label : Label
@export var text_label : Label

func _on_set_note() -> void:
	if not note: return

	text_label.text = note.trimmed_text
	text_label.visible = not Note.string_is_blank(text_label.text)

	var title_is_blank := Note.string_is_blank(note.title)
	title_label.visible = not text_label.visible or not title_is_blank
	title_label.text = (Note.DEFAULT_TITLE if title_is_blank else note.title)
