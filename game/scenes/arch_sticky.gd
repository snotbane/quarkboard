class_name ArchSticky extends EntryInstance

signal clicked(__entry: Entry)
signal unclicked

@export var button : Button

@export var title_label : Label
@export var text_label : Label

func _on_set_entry() -> void:
	if not entry: return

	text_label.text = entry.trimmed_text
	text_label.visible = not Entry.string_is_blank(text_label.text)

	var title_is_blank := Entry.string_is_blank(entry.title)
	title_label.visible = not text_label.visible or not title_is_blank
	title_label.text = (Entry.DEFAULT_TITLE if title_is_blank else entry.title)


func _on_button_pressed() -> void:
	clicked.emit(entry if button.button_pressed else null)


func deselect() -> void:
	if not button.button_pressed: return
	button.button_pressed = false

func select() -> void:
	if button.button_pressed: return
	button.button_pressed = true
