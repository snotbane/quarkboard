class_name ArchEditor extends EntryInstance

@export var main_viewport : Control
@export var title_edit : LineEdit
@export var text_edit : TextEdit
@export var last_modified_label : Label

func _on_set_entry() -> void:
	main_viewport.visible = entry != null

	text_edit.editable = entry != null
	text_edit.text = entry.text if entry else ""

	title_edit.editable = entry != null
	title_edit.placeholder_text = entry.placeholder_title if entry else ""
	title_edit.text = entry.title if entry else ""

	last_modified_label.tooltip_text = entry.time_tooltip if entry else ""

func _on_entry_modified() -> void:
	last_modified_label.tooltip_text = entry.time_tooltip


# func _ready() -> void:
# 	super._ready()


func _process(delta: float) -> void:
	if not entry: return

	last_modified_label.text = entry.last_modified_short_blurb


func _on_title_edit_text_changed() -> void:
	entry.title = title_edit.text


func _on_text_edit_text_changed() -> void:
	entry.text = text_edit.text
	title_edit.placeholder_text = entry.placeholder_title
