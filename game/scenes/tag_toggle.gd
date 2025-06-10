extends PanelContainer

signal text_changed(new_text: String)


@export var tag_label : Button
@export var text : String = "Tag" :
	get: return tag_label.text
	set(value):
		if tag_label.text == value: return
		set_text(value)
func set_text(new_text: String) -> void:
	set_text_no_signal(new_text)
	text_changed.emit(text)
func set_text_no_signal(new_text: String) -> void:
	tag_label.text = new_text


func on_tag_name_changed(new_name: String) -> void:
	set_text_no_signal(new_name)


func on_tag_removed() -> void:
	self.queue_free()
